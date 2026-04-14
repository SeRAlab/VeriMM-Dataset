`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg ld;
    reg [7:0] pi;
    reg rst;
    reg si;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .en(en),
        .ld(ld),
        .pi(pi),
        .rst(rst),
        .si(si),
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
            rst = 1;
            en = 0;
            ld = 0;
            si = 0;
            pi = 8'h00;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Parallel Load 0xA5", test_num);
            reset_dut();
            @(negedge clk);
            ld = 1;
            pi = 8'hA5;
            @(negedge clk);
            ld = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single Right Shift (si=1)", test_num);
            reset_dut();

            @(negedge clk);
            ld = 1; pi = 8'h00;
            @(negedge clk);
            ld = 0; en = 1; si = 1;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Single Right Shift (si=0)", test_num);
            reset_dut();

            @(negedge clk);
            ld = 1; pi = 8'hFF;
            @(negedge clk);
            ld = 0; en = 1; si = 0;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Shift Inhibit (en=0)", test_num);
            reset_dut();

            @(negedge clk);
            ld = 1; pi = 8'h55;
            @(negedge clk);
            ld = 0; en = 0; si = 1;
            @(negedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Load Priority (ld=1, en=1)", test_num);
            reset_dut();

            @(negedge clk);
            ld = 1; pi = 8'h00;
            @(negedge clk);

            ld = 1; en = 1; pi = 8'hAA; si = 1;
            @(negedge clk);
            ld = 0; en = 0;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Multi-bit Shift (Fill with 1s)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1; si = 1;
            for(i=0; i<8; i=i+1) begin
                @(negedge clk);
            end
            en = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Testcase %0d: Full Register Propagation", test_num);
            reset_dut();

            @(negedge clk);
            ld = 1; pi = 8'h80;
            @(negedge clk);
            ld = 0; en = 1; si = 0;

            for(i=0; i<7; i=i+1) begin
                @(negedge clk);
            end
            en = 0;

            #1;


            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
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
        $dumpvars(0,clk, en, ld, pi, rst, si, q);
    end

endmodule
