`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    wire shifted_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .control(control),
        .shifted_clk(shifted_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            control = 2'b00;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing 0-degree phase shift (control=00)", test_num);
            reset_dut();
            control = 2'b00;


            repeat(5) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing 90-degree phase shift (control=01)", test_num);
            reset_dut();
            control = 2'b01;

            repeat(5) @(posedge clk);



            @(posedge clk);
            #4;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing 180-degree phase shift (control=10)", test_num);
            reset_dut();
            control = 2'b10;

            repeat(5) @(posedge clk);



            @(posedge clk);
            #6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing 270-degree phase shift (control=11)", test_num);
            reset_dut();
            control = 2'b11;

            repeat(5) @(posedge clk);



            @(posedge clk);
            #9;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify 0-degree low cycle (control=00)", test_num);
            reset_dut();
            control = 2'b00;

            repeat(5) @(posedge clk);


            @(posedge clk);
            #6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input expected_shifted_clk;
        begin
            if (expected_shifted_clk === (expected_shifted_clk ^ shifted_clk ^ expected_shifted_clk)) begin
                $display("PASS");
                $display("  Outputs: shifted_clk=%b",
                         shifted_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_clk=%b",
                         expected_shifted_clk);
                $display("  Got:      shifted_clk=%b",
                         shifted_clk);
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
        $dumpvars(0,clk, control, shifted_clk);
    end

endmodule
