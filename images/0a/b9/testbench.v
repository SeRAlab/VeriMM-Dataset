`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg en;
    reg rst;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .hash_out(hash_out)
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
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            reset_dut();

            data_in = 128'h0;
            en = 1;
            @(posedge clk);
            en = 0;


            repeat(64) @(posedge clk);


            #1;



            check_outputs(128'hE2C420D020D320D020D320D020D320D0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input", test_num);
            reset_dut();

            data_in = {128{1'b1}};
            en = 1;
            @(posedge clk);
            en = 0;

            repeat(64) @(posedge clk);


            #1;



            check_outputs(128'h9E107D9D372BB68238C12030FA32CA67);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (0xA...A)", test_num);
            reset_dut();

            data_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            en = 1;
            @(posedge clk);
            en = 0;

            repeat(64) @(posedge clk);

            #1;


            check_outputs(128'h5FD4C1D1345D12456A2B3C4D5E6F7081);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hex Sequence Input", test_num);
            reset_dut();

            data_in = 128'h0123456789ABCDEF0123456789ABCDEF;
            en = 1;
            @(posedge clk);
            en = 0;

            repeat(64) @(posedge clk);

            #1;


            check_outputs(128'hFDCBA98765432100FDCBA98765432100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable Latching Test", test_num);
            reset_dut();

            data_in = 128'hDEADC0DEDEADC0DEDEADC0DEDEADC0DE;
            en = 1;
            @(posedge clk);
            en = 0;
            data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            repeat(64) @(posedge clk);


            #1;



            check_outputs(128'h34444547494B4D4F34444547494B4D4F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, data_in, en, rst, hash_out);
    end

endmodule
