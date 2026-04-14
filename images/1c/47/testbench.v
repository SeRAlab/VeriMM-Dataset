`timescale 1ns/1ps

module mux4to1_32bit_tb;

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
    mux4to1_32bit dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select data0 (32'hAAAA_AAAA)", test_num);
        data0 = 32'hAAAA_AAAA;
        data1 = 32'h5555_5555;
        data2 = 32'h1234_5678;
        data3 = 32'h9ABC_DEF0;
        select = 2'b00;
        #10;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select data1 (32'h5555_5555)", test_num);
        data0 = 32'hAAAA_AAAA;
        data1 = 32'h5555_5555;
        data2 = 32'h1234_5678;
        data3 = 32'h9ABC_DEF0;
        select = 2'b01;
        #10;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select data2 (32'h1234_5678)", test_num);
        data0 = 32'hAAAA_AAAA;
        data1 = 32'h5555_5555;
        data2 = 32'h1234_5678;
        data3 = 32'h9ABC_DEF0;
        select = 2'b10;
        #10;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select data3 (32'h9ABC_DEF0)", test_num);
        data0 = 32'hAAAA_AAAA;
        data1 = 32'h5555_5555;
        data2 = 32'h1234_5678;
        data3 = 32'h9ABC_DEF0;
        select = 2'b11;
        #10;
        #1;

        check_outputs(32'h9ABC_DEF0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Boundary condition - All Zeros", test_num);
        data0 = 32'h0000_0000;
        data1 = 32'h0000_0000;
        data2 = 32'h0000_0000;
        data3 = 32'h0000_0000;
        select = 2'b01;
        #10;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary condition - All Ones", test_num);
        data0 = 32'hFFFF_FFFF;
        data1 = 32'hFFFF_FFFF;
        data2 = 32'hFFFF_FFFF;
        data3 = 32'hFFFF_FFFF;
        select = 2'b11;
        #10;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Walking pattern on data0", test_num);
        data0 = 32'hF0F0_F0F0;
        data1 = 32'h0F0F_0F0F;
        data2 = 32'hCCCC_CCCC;
        data3 = 32'h3333_3333;
        select = 2'b00;
        #10;
        #1;

        check_outputs(32'hF0F0_F0F0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Data switching while select is active", test_num);
        data0 = 32'h0;
        data1 = 32'hDEAD_BEEF;
        data2 = 32'h0;
        data3 = 32'h0;
        select = 2'b01;
        #5;
        data1 = 32'hBEEF_CAFE;
        #5;
        #1;

        check_outputs(32'hBEEF_CAFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1_32bit Testbench");
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
