`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr_a;
    reg [7:0] addr_b;
    reg clk;
    reg [63:0] d;
    reg wr_en;
    wire [63:0] q_a;
    wire [63:0] q_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk(clk),
        .d(d),
        .wr_en(wr_en),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_a = 0;
            addr_b = 0;
            d = 0;
            wr_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Port A)", test_num);


            @(posedge clk);
            addr_a = 8'h05;
            d = 64'h123456789ABCDEF0;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;
            addr_a = 8'h05;
            addr_b = 8'h00;

            #2;
            #1;

            check_outputs(64'h123456789ABCDEF0, q_b);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Read", test_num);


            @(posedge clk);
            addr_a = 8'h10;
            d = 64'hAAAA_AAAA_BBBB_BBBB;
            wr_en = 1;


            @(posedge clk);
            addr_a = 8'h20;
            d = 64'hCCCC_CCCC_DDDD_DDDD;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;
            addr_a = 8'h10;
            addr_b = 8'h20;

            #2;
            #1;

            check_outputs(64'hAAAA_AAAA_BBBB_BBBB, 64'hCCCC_CCCC_DDDD_DDDD);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);


            @(posedge clk);
            addr_a = 8'h30;
            d = 64'hFEED_FACE_CAFE_BEEF;
            wr_en = 1;


            @(posedge clk);
            addr_a = 8'h30;
            d = 64'h0000_0000_0000_0000;
            wr_en = 0;

            @(posedge clk);
            addr_a = 8'h30;
            addr_b = 8'h30;

            #2;

            #1;


            check_outputs(64'hFEED_FACE_CAFE_BEEF, 64'hFEED_FACE_CAFE_BEEF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Testing (0x00 and 0xFF)", test_num);


            @(posedge clk);
            addr_a = 8'hFF;
            d = 64'hFFFF_FFFF_FFFF_FFFF;
            wr_en = 1;


            @(posedge clk);
            addr_a = 8'h00;
            d = 64'h0000_0000_0000_0001;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;
            addr_a = 8'hFF;
            addr_b = 8'h00;

            #2;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Update and Simultaneous Port B Access", test_num);


            @(posedge clk);
            addr_a = 8'h40;
            d = 64'h1111_1111_1111_1111;
            wr_en = 1;


            @(posedge clk);
            addr_a = 8'h40;
            addr_b = 8'h40;
            d = 64'h2222_2222_2222_2222;
            wr_en = 1;

            @(posedge clk);
            wr_en = 0;
            #2;

            #1;


            check_outputs(64'h2222_2222_2222_2222, 64'h2222_2222_2222_2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [63:0] expected_q_a;
        input [63:0] expected_q_b;
        begin
            if (expected_q_a === (expected_q_a ^ q_a ^ expected_q_a) &&
                expected_q_b === (expected_q_b ^ q_b ^ expected_q_b)) begin
                $display("PASS");
                $display("  Outputs: q_a=%h, q_b=%h",
                         q_a, q_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_a=%h, q_b=%h",
                         expected_q_a, expected_q_b);
                $display("  Got:      q_a=%h, q_b=%h",
                         q_a, q_b);
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
        $dumpvars(0,addr_a, addr_b, clk, d, wr_en, q_a, q_b);
    end

endmodule
