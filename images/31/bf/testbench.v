`timescale 1ns/1ps

module mpc_control_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_state;
    reg [7:0] target_state;
    wire [7:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_control dut (
        .current_state(current_state),
        .target_state(target_state),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Standard positive difference (Target > Current)", test_num);
            current_state = 8'd25;
            target_state = 8'd100;

            #1;


            check_outputs(8'd75);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Zero difference (Steady State)", test_num);
            current_state = 8'd50;
            target_state = 8'd50;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Negative difference (Target < Current)", test_num);
            current_state = 8'd100;
            target_state = 8'd20;

            #1;


            check_outputs(8'hB0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Maximum range positive", test_num);
            current_state = 8'd0;
            target_state = 8'd255;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Smallest negative step", test_num);
            current_state = 8'd1;
            target_state = 8'd0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Smallest positive step", test_num);
            current_state = 8'd0;
            target_state = 8'd1;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Maximum range negative", test_num);
            current_state = 8'd255;
            target_state = 8'd0;


            #1;



            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mid-range values", test_num);
            current_state = 8'h80;
            target_state = 8'h7F;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_control Testbench");
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
        input [7:0] expected_control_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
