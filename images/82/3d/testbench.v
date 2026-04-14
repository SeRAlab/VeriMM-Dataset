`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr1;
    reg [31:0] addr2;
    reg clk;
    reg [31:0] req1;
    reg [31:0] req2;
    reg [31:0] res1;
    reg [31:0] res2;
    wire [31:0] reqA;
    wire [31:0] reqB;
    wire [31:0] resA;
    wire [31:0] resB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .req1(req1),
        .req2(req2),
        .res1(res1),
        .res2(res2),
        .reqA(reqA),
        .reqB(reqB),
        .resA(resA),
        .resB(resB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr1 <= 32'h0;
            addr2 <= 32'h0;
            req1  <= 32'h0;
            req2  <= 32'h0;
            res1  <= 32'h0;
            res2  <= 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Routing (A=Input1, B=Input2)", test_num);

            addr1 = 32'h00000000;
            addr2 = 32'h00000004;
            req1  = 32'hAAAA_AAAA;
            req2  = 32'hBBBB_BBBB;
            res1  = 32'h1111_1111;
            res2  = 32'h2222_2222;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Swapped Routing (A=Input2, B=Input1)", test_num);

            addr1 = 32'h00000004;
            addr2 = 32'h00000000;
            req1  = 32'hAAAA_AAAA;
            req2  = 32'hBBBB_BBBB;
            res1  = 32'h1111_1111;
            res2  = 32'h2222_2222;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'hAAAA_AAAA, 32'h2222_2222, 32'h1111_1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Broadcast Input 1", test_num);

            addr1 = 32'h00000000;
            addr2 = 32'h00000000;
            req1  = 32'hCAFE_BABE;
            req2  = 32'hDEAD_BEEF;
            res1  = 32'h5555_6666;
            res2  = 32'h7777_8888;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCAFE_BABE, 32'hCAFE_BABE, 32'h5555_6666, 32'h5555_6666);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Broadcast Input 2", test_num);

            addr1 = 32'hFFFF_FFFF;
            addr2 = 32'h0000_000C;
            req1  = 32'h1234_5678;
            req2  = 32'h8765_4321;
            res1  = 32'hAAAA_0000;
            res2  = 32'h0000_BBBB;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h8765_4321, 32'h8765_4321, 32'h0000_BBBB, 32'h0000_BBBB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: High-order Response Bits (Check default/mask conditions)", test_num);

            addr1 = 32'h0000_0000;
            addr2 = 32'h0000_0004;
            req1  = 32'hFFFF_FFFF;
            req2  = 32'hEEEE_EEEE;

            res1  = 32'h0000_0001;
            res2  = 32'h0000_0002;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hFFFF_FFFF, 32'hEEEE_EEEE, 32'h0000_0001, 32'h0000_0002);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Address bits masking check", test_num);

            addr1 = 32'hF0F0_F0F0;
            addr2 = 32'h0000_0004;
            req1  = 32'h1122_3344;
            req2  = 32'h5566_7788;
            res1  = 32'h99AA_BBCC;
            res2  = 32'hDDEE_FF00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h1122_3344, 32'h5566_7788, 32'h99AA_BBCC, 32'hDDEE_FF00);
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
        input [31:0] expected_reqA;
        input [31:0] expected_reqB;
        input [31:0] expected_resA;
        input [31:0] expected_resB;
        begin
            if (expected_reqA === (expected_reqA ^ reqA ^ expected_reqA) &&
                expected_reqB === (expected_reqB ^ reqB ^ expected_reqB) &&
                expected_resA === (expected_resA ^ resA ^ expected_resA) &&
                expected_resB === (expected_resB ^ resB ^ expected_resB)) begin
                $display("PASS");
                $display("  Outputs: reqA=%h, reqB=%h, resA=%h, resB=%h",
                         reqA, reqB, resA, resB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reqA=%h, reqB=%h, resA=%h, resB=%h",
                         expected_reqA, expected_reqB, expected_resA, expected_resB);
                $display("  Got:      reqA=%h, reqB=%h, resA=%h, resB=%h",
                         reqA, reqB, resA, resB);
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
        $dumpvars(0,addr1, addr2, clk, req1, req2, res1, res2, reqA, reqB, resA, resB);
    end

endmodule
