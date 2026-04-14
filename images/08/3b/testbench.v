`timescale 1ns/1ps

module pcie_interface_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg wr_en;
    wire [79:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_interface dut (
        .clk(clk),
        .data_in(data_in),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            data_in = 64'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);

            data_in = 64'h0000_0000_0000_0000;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(80'hA5_0000_0000_0000_0000_5A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);

            data_in = 64'hFFFF_FFFF_FFFF_FFFF;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(80'hA5_FFFF_FFFF_FFFF_FFFF_5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Hex Pattern", test_num);

            data_in = 64'h0123_4567_89AB_CDEF;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(80'hA5_0123_4567_89AB_CDEF_5A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern", test_num);

            data_in = 64'hAAAA_5555_AAAA_5555;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(80'hA5_AAAA_5555_AAAA_5555_5A);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Random-like Data", test_num);

            data_in = 64'hDEADC0DE_FEEDFACE;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(80'hA5_DEADC0DE_FEEDFACE_5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_interface Testbench");
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
        input [79:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, wr_en, data_out);
    end

endmodule
