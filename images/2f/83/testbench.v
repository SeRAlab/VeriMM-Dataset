`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_enable;
    reg [15:0] parallel_in;
    reg shift_enable;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load_enable(load_enable),
        .parallel_in(parallel_in),
        .shift_enable(shift_enable),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            load_enable = 0;
            shift_enable = 0;
            parallel_in = 16'h0000;
            @(negedge clk);

            load_enable = 1;
            parallel_in = 16'h0000;
            @(negedge clk);
            load_enable = 0;
            parallel_in = 16'h0000;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Parallel Load 0xABCD", test_num);
            @(negedge clk);
            parallel_in = 16'hABCD;
            load_enable = 1;
            @(negedge clk);
            load_enable = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Shift Left 1 bit (0x0001 -> 0x0002)", test_num);

            @(negedge clk);
            parallel_in = 16'h0001;
            load_enable = 1;
            @(negedge clk);
            load_enable = 0;

            shift_enable = 1;
            @(negedge clk);
            shift_enable = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Shift Left 8 bits (0x00FF -> 0xFF00)", test_num);

            @(negedge clk);
            parallel_in = 16'h00FF;
            load_enable = 1;
            @(negedge clk);
            load_enable = 0;

            shift_enable = 1;
            repeat(8) @(negedge clk);
            shift_enable = 0;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Simultaneous Load and Shift Priority Check", test_num);
            @(negedge clk);
            parallel_in = 16'h5555;
            load_enable = 1;
            shift_enable = 1;
            @(negedge clk);
            load_enable = 0;
            shift_enable = 0;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Data Persistence with both enables low", test_num);

            @(negedge clk);
            parallel_in = 16'hAAAA;
            load_enable = 1;
            @(negedge clk);
            load_enable = 0;

            repeat(5) @(negedge clk);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Shift MSB out (0x8000 -> 0x0000)", test_num);

            @(negedge clk);
            parallel_in = 16'h8000;
            load_enable = 1;
            @(negedge clk);
            load_enable = 0;

            shift_enable = 1;
            @(negedge clk);
            shift_enable = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Shift 16 times (should be 0)", test_num);

            @(negedge clk);
            parallel_in = 16'hFFFF;
            load_enable = 1;
            @(negedge clk);
            load_enable = 0;

            shift_enable = 1;
            repeat(16) @(negedge clk);
            shift_enable = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, load_enable, parallel_in, shift_enable, parallel_out);
    end

endmodule
