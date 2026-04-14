`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [31:0] data4;
    reg [31:0] data5;
    reg [31:0] data6;
    reg [31:0] data7;
    reg [2:0] sel;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .data6(data6),
        .data7(data7),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Selecting data0", test_num);
        data0 = 32'hAAAA_AAAA;
        data1 = 32'h0000_0001;
        data2 = 32'h0000_0002;
        data3 = 32'h0000_0003;
        data4 = 32'h0000_0004;
        data5 = 32'h0000_0005;
        data6 = 32'h0000_0006;
        data7 = 32'h0000_0007;
        sel = 3'b000;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Selecting data1", test_num);
        data0 = 32'h0000_0000;
        data1 = 32'h5555_5555;
        data2 = 32'h0000_0002;
        data3 = 32'h0000_0003;
        data4 = 32'h0000_0004;
        data5 = 32'h0000_0005;
        data6 = 32'h0000_0006;
        data7 = 32'h0000_0007;
        sel = 3'b001;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Selecting data2", test_num);
        data2 = 32'h1234_5678;
        sel = 3'b010;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Selecting data3", test_num);
        data3 = 32'h8765_4321;
        sel = 3'b011;
        #1;

        check_outputs(32'h8765_4321);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Selecting data4", test_num);
        data4 = 32'hFFFF_FFFF;
        sel = 3'b100;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Selecting data5", test_num);
        data5 = 32'h0000_0000;
        sel = 3'b101;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Selecting data6", test_num);
        data6 = 32'hCAFE_BABE;
        sel = 3'b110;
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Selecting data7", test_num);
        data7 = 32'hDEAD_BEEF;
        sel = 3'b111;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Switching through all selections", test_num);
        data0 = 32'h0; data1 = 32'h1; data2 = 32'h2; data3 = 32'h3;
        data4 = 32'h4; data5 = 32'h5; data6 = 32'h6; data7 = 32'h7;

        sel = 3'b000; #1; if(data_out !== 32'h0) fail_count++; else pass_count++;
        sel = 3'b100; #1; if(data_out !== 32'h4) fail_count++; else pass_count++;
        sel = 3'b111; #1; if(data_out !== 32'h7) fail_count++; else pass_count++;


        #1;



        check_outputs(32'h7);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
