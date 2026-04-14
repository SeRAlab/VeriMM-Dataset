`timescale 1ns/1ps

module reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg en;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_16bit dut (
        .clk(clk),
        .d(d),
        .en(en),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            d = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Data Load with Enable High", test_num);
            reset_dut();
            d = 16'hABCD;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Retention with Enable Low", test_num);
            reset_dut();

            d = 16'h1234;
            en = 1;
            @(posedge clk);
            #1;

            d = 16'h5678;
            en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Synchronous Reset Priority Over Enable", test_num);
            reset_dut();

            d = 16'hFFFF;
            en = 1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verifying Load of All Ones (0xFFFF)", test_num);
            reset_dut();
            d = 16'hFFFF;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Verifying Load of Alternating Bits", test_num);
            reset_dut();
            d = 16'h5A5A;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Multiple Clock Cycles with Constant Enable", test_num);
            reset_dut();
            en = 1;
            d = 16'h1111; @(posedge clk);
            d = 16'h2222; @(posedge clk);
            d = 16'h3333; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Changing Data while Enable is Low", test_num);
            reset_dut();

            d = 16'hAAAA;
            en = 1;
            @(posedge clk);
            #1;

            en = 0;
            d = 16'h1111; @(posedge clk);
            d = 16'h2222; @(posedge clk);
            d = 16'h3333; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_16bit Testbench");
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
        $dumpvars(0,clk, d, en, rst, q);
    end

endmodule
