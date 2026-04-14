`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_position;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    wire [15:0] new_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .current_position(current_position),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .new_position(new_position)
    );
    task testcase001;

    begin
        test_num = 1;
        current_position = 16'sd500;
        learning_rate = 16'sd5;
        gradient = 16'sd20;

        #1;


        check_outputs(16'sd400);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        current_position = 16'sd1000;
        learning_rate = 16'sd10;
        gradient = 16'sd0;

        #1;


        check_outputs(16'sd1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        current_position = 16'sd100;
        learning_rate = 16'sd2;
        gradient = -16'sd50;

        #1;


        check_outputs(16'sd200);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        current_position = -16'sd100;
        learning_rate = 16'sd1;
        gradient = 16'sd10;

        #1;


        check_outputs(-16'sd110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        current_position = 16'sd0;
        learning_rate = 16'sd100;
        gradient = 16'sd100;

        #1;


        check_outputs(-16'sd10000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        current_position = 16'sh7FFF;
        learning_rate = 16'sd2;
        gradient = 16'sd1;

        #1;


        check_outputs(16'sh7FFD);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        current_position = 16'sh8000;
        learning_rate = 16'sd1;
        gradient = 16'sd1;

        #1;


        check_outputs(16'sh7FFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        current_position = 16'sd100;
        learning_rate = -16'sd2;
        gradient = 16'sd10;

        #1;


        check_outputs(16'sd120);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [15:0] expected_new_position;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_position === (expected_new_position ^ new_position ^ expected_new_position)) begin
                $display("PASS");
                $display("  Outputs: new_position=%h",
                         new_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_position=%h",
                         expected_new_position);
                $display("  Got:      new_position=%h",
                         new_position);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
