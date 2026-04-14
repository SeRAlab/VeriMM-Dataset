`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg ld_en;
    reg reset;
    reg sh_en;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .d(d),
        .ld_en(ld_en),
        .reset(reset),
        .sh_en(sh_en),
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
            ld_en = 0;
            sh_en = 0;
            d = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();

            d = 16'hA5A5;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Shift Left", test_num);
            reset_dut();


            d = 16'h0001;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;


            sh_en = 1;
            @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multiple Shifts", test_num);
            reset_dut();


            d = 16'h0001;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;


            sh_en = 1;
            repeat(4) @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(16'h0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Shift Out MSB", test_num);
            reset_dut();


            d = 16'h8000;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;


            sh_en = 1;
            @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Priority Check (Load vs Shift)", test_num);
            reset_dut();


            d = 16'h1111;
            ld_en = 1;
            @(posedge clk);
            #1;


            d = 16'h2222;
            ld_en = 1;
            sh_en = 1;
            @(posedge clk);
            #1;
            ld_en = 0;
            sh_en = 0;


            #1;



            check_outputs(16'h2222);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Hold Value (No Enable)", test_num);
            reset_dut();


            d = 16'hABCD;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Shift to MSB", test_num);
            reset_dut();

            d = 16'h0001;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;

            sh_en = 1;
            repeat(15) @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(16'h8000);
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
        $dumpvars(0,clk, d, ld_en, reset, sh_en, q);
    end

endmodule
