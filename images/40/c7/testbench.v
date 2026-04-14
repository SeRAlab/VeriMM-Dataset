`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [1:0] sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select data0 (sel=00)", test_num);
            data0 = 32'h1111_1111;
            data1 = 32'h2222_2222;
            data2 = 32'h3333_3333;
            data3 = 32'h4444_4444;
            sel = 2'b00;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select data1 (sel=01)", test_num);
            data0 = 32'hAAAA_AAAA;
            data1 = 32'hBBBB_BBBB;
            data2 = 32'hCCCC_CCCC;
            data3 = 32'hDDDD_DDDD;
            sel = 2'b01;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select data2 (sel=10)", test_num);
            data0 = 32'h1234_5678;
            data1 = 32'h8765_4321;
            data2 = 32'hFEED_BEEF;
            data3 = 32'hCAFE_BABE;
            sel = 2'b10;
            #1;

            check_outputs(32'hFEED_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select data3 (sel=11)", test_num);
            data0 = 32'h0000_0000;
            data1 = 32'hFFFF_FFFF;
            data2 = 32'h5555_5555;
            data3 = 32'h9999_9999;
            sel = 2'b11;
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary - All Zeros", test_num);
            data0 = 32'h0; data1 = 32'h0; data2 = 32'h0; data3 = 32'h0;
            sel = 2'b00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary - All Ones", test_num);
            data0 = 32'hFFFF_FFFF;
            data1 = 32'hFFFF_FFFF;
            data2 = 32'hFFFF_FFFF;
            data3 = 32'hFFFF_FFFF;
            sel = 2'b11;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Walking Bit Test on Data2", test_num);
            data0 = 32'h0; data1 = 32'h0; data3 = 32'h0;
            data2 = 32'h0000_0001;
            sel = 2'b10;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Alternating Bits on Data1", test_num);
            data0 = 32'h0; data2 = 32'h0; data3 = 32'h0;
            data1 = 32'h5A5A_5A5A;
            sel = 2'b01;
            #1;

            check_outputs(32'h5A5A_5A5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

endmodule
