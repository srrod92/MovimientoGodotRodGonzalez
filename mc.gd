extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = 800.0
const DASH_VELOCITY = 1200.0
const TIMETOFALL = 3
var timeToFall = TIMETOFALL
var canDash = true
var isDashing =false
var canJump = true
var canClimb1 = false
var canClimb2 = false
var canClimb = false
var isCliming = false

const TIMEDASHING = 0.3
var timeDashing = TIMEDASHING

  



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	canDash = true
	isDashing =false
	canJump = true
	canClimb1 = false
	canClimb2 = false
	canClimb = false
	isCliming = false

func _physics_process(delta):
	
	if isDashing:  #distancia/tiempo del dash
		timeDashing -= delta
		
		if timeDashing < 0:
			isDashing = false
			timeDashing = TIMEDASHING
			print("el Timer del dash anda")
			
	if isCliming:   #cansancio al escalar
		timeToFall-=delta
		print(timeToFall)
		print(isCliming)
		if timeToFall < 0:
			canClimb1 = false
			isCliming = false
			print("se canso")
			
	if canClimb1 and canClimb2:   #Si las dos variables de escalar son verdaderas puede escalar
		canClimb = true
	else:
		canClimb = false
	
	
	if not is_on_floor() and not isCliming :  #gravedad
		velocity.y += gravity*delta
		
	else: #se reinicia la habilidad de scalar, de saltar
		canDash = true
		canJump = true
		canClimb1 = true
		if is_on_floor(): #Reinicia el cansancio solo al tocar el suelo
			timeToFall=TIMETOFALL
		
	if canClimb and Input.is_action_pressed("climb") and not isDashing:  # si puede escalar y apreta el boton de escalar esta escalando
		isCliming = true
	else: # si no, no esta escalando
		isCliming = false
	
	if Input.is_action_just_pressed("jump") and canJump:  # salto
		velocity.y -= JUMP_VELOCITY
		canJump = false

	
	if Input.is_action_pressed("right")and not isDashing:  #movimiento a la derecha
		position.x += SPEED*delta
		
	if (not Input.is_action_pressed("right") or not Input.is_action_pressed("lefth")) and not isDashing: # si no apreta las teclas de movimiento lateral y no dashea detiene la fuerza en el eje x
		velocity.x = 0
		
	if isCliming and (not Input.is_action_pressed("down") or not Input.is_action_pressed("up")): # si esta escalando pero no apreta arriba o abajo detiene todas las fuerzas en el eje y
		velocity.y =0
		
	if Input.is_action_pressed("lefth") and not isDashing:  # si no esta dasheando y apreta izquierda se mueve
		position.x -= SPEED*delta
		
	if Input.is_action_pressed("up")and isCliming: #si apreta arriba y esta escalando sube
		position.y -= (SPEED/2)*delta
		
	if Input.is_action_pressed("down") and isCliming:  #si se apreta abajo y esta escalando baja
		position.y += (SPEED/2)*delta
		
		

	if Input.is_action_just_pressed("dash") and canDash and not isDashing:   #chequea si puede dashear al presionar el boton de dash
		if Input.is_action_pressed("lefth") and Input.is_action_pressed("up")and not isDashing:  #dash para arriba izquierda
			velocity.x -= DASH_VELOCITY/1.2
			velocity.y -= DASH_VELOCITY/1.8
			canDash = false
			isDashing = true
			print("Dashea en diagonal izquierda")
			
		if Input.is_action_pressed("right") and Input.is_action_pressed("up")and not isDashing:  #dash para arriba izquierda
					velocity.x += DASH_VELOCITY/1.2
					velocity.y -= DASH_VELOCITY/1.8
					canDash = false
					isDashing = true
				
		if Input.is_action_pressed("lefth") and not isDashing:  #Dash para la izquierda
			velocity.x -= DASH_VELOCITY
			canDash = false
			isDashing = true
			print("dashea a la izquierda")
			
		if Input.is_action_pressed("right") and not isDashing:  #Dash para la derecha
			velocity.x += DASH_VELOCITY
			canDash = false
			isDashing = true
			print("Dashea para la derecha")
			
			
		if Input.is_action_pressed("up")and not isDashing:  #Dash para arriba
			velocity.y -=DASH_VELOCITY
			canDash = false
			isDashing = true
			
		if Input.is_action_pressed("down")and not isDashing:  #Dash para abajo
			velocity.y += DASH_VELOCITY
			canDash = false
			isDashing = true
			

	
	
	
	move_and_slide()



func _on_area_2d_2_body_entered(body): #Modifica la segunda variable de escalar/ hace que escalar sea posible
	canClimb2 = true
	
	
	


func _on_area_2d_2_body_exited(body): #modifica la segunda variable de escalar/ hace que escalar no sea posible
	canClimb2 = false 
