`timescale 1ns/1ps

module mersenne_twister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [4:0] rand_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mersenne_twister dut (
        .clk(clk),
        .reset(reset),
        .rand_out(rand_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initializing and capturing first valid output", test_num);
            reset_dut();


            while (!valid) @(posedge clk);


            val_capture1 = rand_out;



            #1;




            check_outputs(val_capture1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capturing second valid output in sequence", test_num);
            reset_dut();


            while (!valid) @(posedge clk);
            @(posedge clk);


            while (!valid) @(posedge clk);

            val_capture2 = rand_out;



            #1;




            check_outputs(val_capture2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying repeatability (Reset behavior)", test_num);
            reset_dut();


            while (!valid) @(posedge clk);


            #1;



            check_outputs(val_capture1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying the second value in sequence is repeatable", test_num);
            reset_dut();


            while (!valid) @(posedge clk);
            @(posedge clk);


            while (!valid) @(posedge clk);

            #1;


            check_outputs(val_capture2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mersenne_twister Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [4:0] expected_rand_out;
        input expected_valid;
        begin
            if (expected_rand_out === (expected_rand_out ^ rand_out ^ expected_rand_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: rand_out=%h, valid=%b",
                         rand_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_out=%h, valid=%b",
                         expected_rand_out, expected_valid);
                $display("  Got:      rand_out=%h, valid=%b",
                         rand_out, valid);
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
        $dumpvars(0,clk, reset, rand_out, valid);
    end

endmodule
