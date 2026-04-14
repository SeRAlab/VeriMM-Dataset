`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [1:0] select;
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
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data0", test_num);
            data0 = 32'hAAAA_BBBB;
            data1 = 32'h1111_1111;
            data2 = 32'h2222_2222;
            data3 = 32'h3333_3333;
            select = 2'b00;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data1", test_num);
            data0 = 32'h0000_0000;
            data1 = 32'h5555_6666;
            data2 = 32'h7777_8888;
            data3 = 32'h9999_AAAA;
            select = 2'b01;
            #1;

            check_outputs(32'h5555_6666);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data2", test_num);
            data0 = 32'hDEAD_BEEF;
            data1 = 32'hCAFE_BABE;
            data2 = 32'h1234_5678;
            data3 = 32'h8765_4321;
            select = 2'b10;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data3", test_num);
            data0 = 32'hFFFF_FFFF;
            data1 = 32'h0000_0000;
            data2 = 32'hAAAA_5555;
            data3 = 32'hBCDE_F012;
            select = 2'b11;
            #1;

            check_outputs(32'hBCDE_F012);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Switching select on stable inputs", test_num);
            data0 = 32'h0000_0001;
            data1 = 32'h0000_0002;
            data2 = 32'h0000_0004;
            data3 = 32'h0000_0008;

            select = 2'b10;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs identical", test_num);
            data0 = 32'h8888_8888;
            data1 = 32'h8888_8888;
            data2 = 32'h8888_8888;
            data3 = 32'h8888_8888;
            select = 2'b01;
            #1;

            check_outputs(32'h8888_8888);
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
