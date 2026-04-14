`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire [7:0] po;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .po(po)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            si = 0;
            #15;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift All Zeros", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                si = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift All Ones", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                si = 1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern 10101010", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                si = (i % 2 == 0) ? 1 : 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern 01010101", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                si = (i % 2 == 0) ? 0 : 1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit (10000000)", test_num);
            reset_dut();
            si = 1; @(posedge clk); #1;
            for (i = 0; i < 7; i = i + 1) begin
                si = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit (00000001)", test_num);
            reset_dut();
            for (i = 0; i < 7; i = i + 1) begin
                si = 0;
                @(posedge clk);
                #1;
            end
            si = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Check (Shift 12 bits)", test_num);
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                si = 1; @(posedge clk); #1;
            end


            si = 1; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 1; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 1; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 1; @(posedge clk); #1;


            #1;



            check_outputs(8'hA5);
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
        input [7:0] expected_po;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po)) begin
                $display("PASS");
                $display("  Outputs: po=%h",
                         po);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h",
                         expected_po);
                $display("  Got:      po=%h",
                         po);
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
        $dumpvars(0,clk, rst, si, po);
    end

endmodule
