(* Data definitions *)

(* Date is an SML value of type int*int*int *)
(* interp. represents a reasonable date where 
           the first part is the year ( Natural ), 
           the second part is the month ( Natural[1, 12] ), 
           and the third part is the day ( Natural[1, 31] ) (depending on the month). *)
(* CAVEATS: Your solutions need to work correctly only for reasonable Dates, 
           but do not check for reasonable Dates (that is a challenge problem) and many of your functions will
           naturally work correctly for some/all non-reasonable Dates. *)

(* fun fn_for_date(date: int*int*int) = 
      (...(#1 date)
          (#2 date)
          (#3 date))
*)

(* (Listof Date) is one of:
   - []
   - Date::(Listof Date)
*)
(* interp. a list of reasonable date (Date) *)

(* fn_for_list_of_date(dates: (int*int*int) list) = 
      if null dates
      then (...)
      else (... (hd dates)
                (fn_for_list_of_date(tl dates)))
*)

(* Constants *)

val last_day_of_months = [31, 28, 31, 30, 31, 30, 31, 31, 31, 31, 30, 31]
val months = ["January","February","March","April","May","June","July","August","September","October","November","December"]			     

(* Functions *)
		 

(* Date, Date -> Date *)
(* Takes two tuples representing two dates and returns the first date if 
it comes before the second date and vice versa *)
fun is_older (first_date : int * int * int, sec_date: int * int * int) =
    if (#1 first_date) < (#1 sec_date)
    then true
    else if (#1 first_date) = (#1 sec_date) andalso (#2 first_date) < (#2 sec_date)
    then true
    else if (#2 first_date) = (#2 sec_date) andalso (#3 first_date) < (#3 sec_date)
    then true
    else false

(* (listof Date), Natural[1, 12] -> Natural *)	     
(* Given a list of dates and a month and produces the number of 
 * dates that are in the given month *)
fun number_in_month (date : (int * int * int) list, month : int) =
    if null date
    then 0
    else let val tl_ans = number_in_month((tl date), month)
	 in
	     if #2 (hd date) = month
	     then 1 + tl_ans 
	     else tl_ans
	 end

(* (listof Date), (listof Natural[1,12]) -> Natural *)
(* Given a list of dates and a list of months, produces the number of 
 * dates in any of the given month in the list *)
fun number_in_months (dates : (int * int * int) list, months : int list) =
    if null months orelse null dates
    then 0
    else let val nim = number_in_month((tl dates), (hd months))
	 in
	     if #2 (hd dates) = (hd months) 
	     then 1 + nim + number_in_months((tl dates), (tl months))
	     else nim + number_in_months(dates, (tl months))
	 end

(* (listof Date), int -> (listof Date) *)
(* Given a list of dates and a month and produces a list of 
 * dates in the given month in order *)
fun dates_in_month (date: (int * int * int) list, month : int) =
    if null date
    then []
    else let val tl_ans = dates_in_month((tl date), month)
	 in
	     if #2 (hd date) = month
	     then hd date :: tl_ans
	     else tl_ans
	 end

(* (listof Date), (listof Natural[1,12]) -> (listof Dates) *)
(* Given a list of dates and a list of months and produces a list of 
 * dates in the given month in order *)
fun dates_in_months (dates: (int * int * int) list, months : int list) =
   if null months orelse null dates
   then []
   else let val dim = dates_in_month((tl dates), hd months)
	in
	    if #2 (hd dates) = hd months
	    then [hd dates] @ dim @ dates_in_months((tl dates), (tl months)) 
	    else dim @ dates_in_months(dates, (tl months))
	end

(* (listof String), Natural[12,1] -> String *)
(* Takes the list of months and n and produces the nth element of the list *)
fun get_nth(xs: string list, n: int) =
    if n = 1
    then hd xs 
    else get_nth(tl xs, n - 1)

(* Date -> String *)
(* Takes a date and produces the date in the string format (January 30, 2020 for example) *)
fun date_to_string(date: int * int * int) =
    let	val month = get_nth(months, (#2 date))
    in
	month ^ " " ^ Int.toString (#3 date) ^ ", " ^ Int.toString (#1 date)
    end

(* Natural, (listof Natural) -> Natural *)
(* produces the index of the first element in xs whose addition with 
 * previous elements makes the total greater than sum *)
(* ASSUME: the entire list sums to more than the passed in value; 
 *         it is okay for an exception to occur if this is not the case. *)
fun number_before_reaching_sum(sum: int, xs: int list) =
    if sum <= hd xs
    then 0
    else 1 + number_before_reaching_sum(sum - (hd xs), tl xs)

(* Natural[1, 365] -> Natural[1,12] *)
(* Takes a day of the year and returns what month that day is in (int) *)
fun what_month(day: int) =
    number_before_reaching_sum(day, last_day_of_months)

(* Natural[1,365], Natural[1,365] -> (listof Natural[1,12]) *)
(*  takes two days of the year day1 and day2 and returns an int list [m1,m2,...,mn] where 
 *  m1 is the month of day1, 
 *  m2 is the month of day1+1, ..., and 
 *  mn is the month of day day2.
 * NOTE: the result will have length day2 - day1 + 1 or length 0 if day1>day2 *)
fun month_range(day1: int, day2: int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2) 

(* (listof Date) -> Date Option *)
(* Given a list of dates produces some "oldest date" if there's one or none if there isn't *)
fun oldest(dates: (int * int * int) list) =
    if null dates
    then NONE
    else let
	    (* (listof Date) -> Date *)
	    (* given a list of dates produces the oldest date *) 
	    fun nonempty_oldest(ds: (int * int * int) list) =
		if null (tl ds)
		then hd ds
		else let val tl_ans = nonempty_oldest(tl ds)
		     in
			 if (#1 (hd ds)) < (#1 (tl_ans)) 
			 then hd ds
			 else if (#1 (hd ds)) = (#1 (tl_ans)) andalso (#2 (hd ds)) < (#2 (tl_ans))
			 then hd ds
			 else if (#1 (hd ds)) = (#1 (tl_ans)) andalso (#2 (hd ds)) = (#2 (tl_ans)) andalso (#3 (hd ds)) < (#3 tl_ans)
			 then hd ds
			 else tl_ans
		     end
	 in
	     SOME (nonempty_oldest dates)
	 end
 	
	

			

			
	
	
	
	
	
	
	
	
	
			       
	
	
			 
				
		
	
    

	     
			
			
	     
			
			
			

			
	     
	     
				    


