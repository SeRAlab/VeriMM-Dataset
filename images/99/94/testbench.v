`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_in;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
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
            parallel_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Parallel Load Check (0xABCD)", test_num);
            reset_dut();
            load <= 1;
            parallel_in <= 16'hABCD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Left Shift Check", test_num);
            reset_dut();

            load <= 1;
            parallel_in <= 16'h0001;
            @(posedge clk);

            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: 4-bit Left Shift Check", test_num);
            reset_dut();

            load <= 1;
            parallel_in <= 16'h000F;
            @(posedge clk);

            load <= 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Shift Out MSB Check", test_num);
            reset_dut();

            load <= 1;
            parallel_in <= 16'h8000;
            @(posedge clk);

            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Parallel Load Priority Check", test_num);
            reset_dut();

            load <= 1;
            parallel_in <= 16'h1111;
            @(posedge clk);

            load <= 1;
            parallel_in <= 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Full Register Shift Check (15 cycles)", test_num);
            reset_dut();
            load <= 1;
            parallel_in <= 16'h0001;
            @(posedge clk);
            load <= 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset Priority over Load Check", test_num);
            reset_dut();

            reset <= 1;
            load <= 1;
            parallel_in <= 16'h5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
            reset <= 0;
            load <= 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_16bit Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, load, parallel_in, reset, q);
    end

endmodule
