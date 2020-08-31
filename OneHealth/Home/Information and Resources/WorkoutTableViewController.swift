//
//  WorkoutTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import UIKit

class WorkoutTableViewController: UITableViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var todaysWorkoutLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    
    // MARK: - Properties
    
    var workout: String? = ""
    let formatter  = DateFormatter()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineExercise()
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func determineExercise() {
        formatter.dateFormat = "yyyy-MM-dd"
        let day = getDayOfWeek(formatter.string(from: Date()))
        if day == 1 || day == 7 {
            todaysWorkoutLabel.text = "Rest! Or, if you'd like, go on a walk or jog."
            workoutLabel.text = ""
        } else if day == 3 || day == 5 {
            todaysWorkoutLabel.text = "Cardio today!"
            workoutLabel.text = """
            Any cardio that is at the intensity of at least a 30 minute run.
            """
        } else if day == 2 {
            todaysWorkoutLabel.text = "Today's Workout: Abs"
            workoutLabel.text = """
             Do three times:
             
             1. Sit-up: 15-20 reps
             
             2. Leg raises: 15-20 reps (30 sec rest)
             
             3. Jackknife sit up: 15-20 reps
             
             4. Leg pull in: 15-20 reps (30 sec rest)
             
             5. Toe touchers: 15-20 reps
             
             6. Crunches: 15-20 reps (30 second rest)
             
             7. Reverse crunch: 15-20 reps
             
             (1-2 minute rest)
             Repeat 3 times.
            """
            
        } else if day == 4 {
            todaysWorkoutLabel.text = "Today's Workout: Chest/Shoulders/Triceps"
            workoutLabel.text = """
            Barbell Bicep Curl (Arms about shoulder width apart, heels a little less than shoulder width and core tight, brings arms forward slightly with elbows slightly in front of hips, make sure arms are fully locked out, curl all the way to the top and squeeze the biceps as hard as you can, breathe out on way up, bring to starting position and flex triceps but don’t let biceps go limp, breathe in on the way down, control negative 2-3 seconds): 60 second rest

            Choose your desired weight and do 4 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Lat Pulldown (push off toes so thighs lock into place under pad, core tight, grab all the way out, bring halfway down to and touch the chest, barbell should be as close to body as possible and elbows should always be above the wrists): 60 second rest
            
            Choose your desired weight and do 4 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Barbell Upright Row (Feet shoulder width apart, spine neutral, arms shoulder width apart, palms facing in, contract core, retract shoulder blades and bring up bar to chin, breathe out on way up, control the negative 2-3 seconds and breathe in): 30 second rest
            
            Choose your desired weight and do 5 sets x 8-15 reps. Over time, try to get to 15 reps with this weight then up weight and repeat.

            Dumbbell Bent-Over Row (Non working knee and foot on bench, non working hand a little further out than straight out with palm on bench, body totally parallel to the bench, working foot out to the side and slightly back, start with working arm straight down, breathe out on way up, use a hook grip, pull back and up towards the hip, dumbbell as close to the torso as possible, end with arm up as much as you can, 2-3 second controlled negative and bring dumbbell all the way down, pause at the lowest point to feel weighted stretch): 30 second rest
            
            Choose your desired weight and do 5 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Barbell Reverse Curl (Shoulder width grip, palms facing towards you, legs about shoulder width, keep elbows in front of hips and away from torso, bring bar up as much as you can, control negative 2-3 seconds): 30 second rest
            
            Choose your desired weight and do 5 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Dumbbell Shrug (feet shoulder width apart, dumbbells in hand, retract shoulder blades, elevate shoulders up and back until traps are fully contracted, have this take 1-2 seconds, don’t roll shoulders as its a straight up and down motion,  pause at the top of the movement slowly control negative for 2-3 seconds): 30 second rest

            Choose your desired weight and do 4 sets x 10-15 reps. Over time, try to get to 15 reps with this weight then up weight and repeat.
            """
        } else {
            todaysWorkoutLabel.text = "Today's Workout: Biceps/Back"
            workoutLabel.text = """
            Bench (ring finger on ring on bar, keep wrists straight, get shoulder blades together, bring arms down across the nipple line, bring arms down 90 degrees, breathe in on the way down, breathe out on the way up, do 2-3 second negative): 2 min rest
            
            Choose your desired weight and do 5 sets. On the first two sets, perform 7 reps. Then 6, then 4, then 3. If you can't do all of the reps, go until failure. When you can do all the reps, up the weight and then repeat.
            
            Choose a lighter weight and do 70 reps. If you fail before 30, lower the weight and try to get to 30. Once you can get to 30, up the weight. Repeat.

            Seated Dumbbell Shoulder Press (Seat totally upright, feet firmly planted on the ground a bit greater than shoulder width, keep head and back neutral against the bench, arms should be in front of body a little bit, palms face directly forward with elbows down 90 degrees, breathe in on the way down, push straight up, breathe out on the way up, control the negative 2-3 seconds and come down with elbows a bit in front of the body): 60 second rest
            
            Choose your desired weight and do 4 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Barbell Skull Crusher (Lay down on flat bench, hook in feet, keep back flat and core tight, hold barbell directly overhead, let arms fall back until barbell is behind head, push straight out and breathe out, control the negative, 2-3 seconds) 60 second rest
            
            Choose your desired weight and do 4 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Incline Bench (shoulders back, bar comes down to chest right above nipples, elbows beneath the wrists not flared, grip just over shoulder width, flex core and glutes, knees out wide and feet flat, take a deep breath on the way down, do 2-3 second negative): 2 min of rest

            Choose your desired weight and do 5 sets. On the first two sets, perform 7 reps. Then 6, then 4, then 3. If you can't do all of the reps, go until failure. When you can do all the reps, up the weight and then repeat.

            Rope pull down (chest up, shoulder blades together and tight, core tight, grab rope at arm length, bring straight down and fully extend arms, 2-3 second negative and bring up fully, breathe out on the way down, breathe in on the way up) 30 second rest

            Choose your desired weight and do 5 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.

            Bent Over Fly (Bend over, back arched, shoulder blades pinches, arms slightly bent at elbows, bring weights up until arm is straight, breathe out as you open up your arms and keep core tight, then control the negative on the way down) 30 second rest

            Choose your desired weight and do 5 sets x 6-10 reps. Over time, try to get to 10 reps with this weight then up weight and repeat.
            """
        }
 
    }
}

