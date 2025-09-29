<form id="forgotForm">
  <label>Email: <input type="email" name="email" id="email" required></label>
  <button type="submit">Send reset link</button>
</form>

<div id="msg"></div>

<script>
document.getElementById('forgotForm').addEventListener('submit', function(e){
  e.preventDefault();
  var email = document.getElementById('email').value;
  var params = new URLSearchParams();
  params.append('email', email);

  fetch('${pageContext.request.contextPath}/ForgotPasswordServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params.toString()
  }).then(function(res){ return res.json(); })
    .then(function(data){
      var el = document.getElementById('msg');
      if(data.status === 'ok'){
        el.style.color = 'green';
        el.innerText = data.message;
      } else {
        el.style.color = 'red';
        el.innerText = data.message || 'Error occurred';
      }
    }).catch(function(err){
      var el = document.getElementById('msg');
      el.style.color = 'red';
      el.innerText = 'Server error';
    });
});
</script>
