`timescale 1ns/1ps

module fsm_model_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire G_next;
    wire H_next;
    wire I_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_model dut (
        .in(in),
        .state(state),
        .G_next(G_next),
        .H_next(H_next),
        .I_next(I_next),
        .out(out)
    );
    task testcase001;

        begin
            $display("\nRunning testcase001: State G, Input 0");
            test_num = test_num + 1;
            state = 3'b001;
            in = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: State G, Input 1");
            test_num = test_num + 1;
            state = 3'b001;
            in = 1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: State H, Input 0");
            test_num = test_num + 1;
            state = 3'b010;
            in = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: State H, Input 1");
            test_num = test_num + 1;
            state = 3'b010;
            in = 1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: State I, Input 0");
            test_num = test_num + 1;
            state = 3'b100;
            in = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: State I, Input 1");
            test_num = test_num + 1;
            state = 3'b100;
            in = 1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_model Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_G_next;
        input expected_H_next;
        input expected_I_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G_next === (expected_G_next ^ G_next ^ expected_G_next) &&
                expected_H_next === (expected_H_next ^ H_next ^ expected_H_next) &&
                expected_I_next === (expected_I_next ^ I_next ^ expected_I_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: G_next=%b, H_next=%b, I_next=%b, out=%b",
                         G_next, H_next, I_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G_next=%b, H_next=%b, I_next=%b, out=%b",
                         expected_G_next, expected_H_next, expected_I_next, expected_out);
                $display("  Got:      G_next=%b, H_next=%b, I_next=%b, out=%b",
                         G_next, H_next, I_next, out);
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
