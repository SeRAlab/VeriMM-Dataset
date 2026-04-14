`timescale 1ns/1ps

module ShiftRegister8Bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg load;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister8Bit dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            data = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Parallel Load Operation", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hA5;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Single Shift Left Operation", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h01;
            @(negedge clk);
            load = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Multiple Shifts Left", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h01;
            @(negedge clk);
            load = 0;
            repeat (7) @(negedge clk);

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Shift until empty", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hFF;
            @(negedge clk);
            load = 0;
            repeat (8) @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Load Priority Over Shift", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h55;
            @(negedge clk);

            data = 8'hAA;
            load = 1;
            @(negedge clk);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Asynchronous Reset Mid-operation", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hFF;
            @(negedge clk);
            load = 0;
            #2;
            reset = 1;
            #2;

            #1;


            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Complex Sequence", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hC3;
            @(negedge clk);
            load = 0;
            repeat (2) @(negedge clk);


            #1;



            check_outputs(8'h0C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRegister8Bit Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, load, reset, q);
    end

endmodule
