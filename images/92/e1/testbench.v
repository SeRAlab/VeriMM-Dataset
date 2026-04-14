`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            parallel_in = 8'h00;
            @(negedge clk);
            load = 0;
            parallel_in = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0xA5", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'hA5;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x80 and Shift Right Once", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'h80;
            @(negedge clk);
            load = 0;

            @(negedge clk);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xF0 and Shift Right 4 times", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'hF0;
            @(negedge clk);
            load = 0;


            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify MSB Zero-fill", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'h01;
            @(negedge clk);
            load = 0;

            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Shift Out (8 cycles)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'hFF;
            @(negedge clk);
            load = 0;

            repeat(8) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Pattern 0xAA twice", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'hAA;
            @(negedge clk);
            load = 0;

            repeat(2) @(negedge clk);
            #1;

            check_outputs(8'h2A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, load, parallel_in, q);
    end

endmodule
