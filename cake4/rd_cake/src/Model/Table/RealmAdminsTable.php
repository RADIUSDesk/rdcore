<?php

namespace App\Model\Table;

use Cake\ORM\Table;
use Cake\Validation\Validator;

class RealmAdminsTable extends Table {

    public function initialize(array $config):void{
        $this->addBehavior('Timestamp');           
     	$this->belongsTo('Realms', [
            'className' => 'Realms',
            'foreignKey' => 'realm_id'
        ]);
        $this->belongsTo('Users', [
            'className' => 'Users',
            'foreignKey' => 'user_id'
        ]);                   
    }      
}
