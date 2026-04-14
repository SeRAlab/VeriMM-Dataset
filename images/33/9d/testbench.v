`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 1;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and Idle Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to Transmitting", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 0;


            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to Receiving", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 0;



            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stop Condition - Return to Idle", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 0;
            repeat (2) @(posedge clk);


            repeat (8) begin
                @(negedge clk);
                data_in = ~data_in;
            end


            @(negedge clk);
            data_in = 0;
            @(posedge clk);
            #2;
            data_in = 1;

            repeat (2) @(posedge clk);


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Loopback/Output Check", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 0;
            @(posedge clk);


            @(negedge clk);
            data_in = 1;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_data_out;
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%b, state=%h",
                         data_out, state);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, reset, data_out, state);
    end

endmodule
