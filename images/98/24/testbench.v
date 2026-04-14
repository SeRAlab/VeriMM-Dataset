`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUresult;
    reg [31:0] Memaddr;
    reg [31:0] databus;
    reg [1:0] forward;
    reg [31:0] writedata;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUresult(ALUresult),
        .Memaddr(Memaddr),
        .databus(databus),
        .forward(forward),
        .writedata(writedata),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select databus (00)", test_num);
            forward = 2'b00;
            databus = 32'hAAAA_AAAA;
            ALUresult = 32'h1111_1111;
            Memaddr = 32'h2222_2222;
            writedata = 32'h3333_3333;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select ALUresult (01)", test_num);
            forward = 2'b01;
            databus = 32'hAAAA_AAAA;
            ALUresult = 32'hBBBB_BBBB;
            Memaddr = 32'h2222_2222;
            writedata = 32'h3333_3333;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Memaddr (10)", test_num);
            forward = 2'b10;
            databus = 32'hAAAA_AAAA;
            ALUresult = 32'hBBBB_BBBB;
            Memaddr = 32'hCCCC_CCCC;
            writedata = 32'h3333_3333;
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select writedata (11)", test_num);
            forward = 2'b11;
            databus = 32'hAAAA_AAAA;
            ALUresult = 32'hBBBB_BBBB;
            Memaddr = 32'hCCCC_CCCC;
            writedata = 32'hDDDD_DDDD;
            #1;

            check_outputs(32'hDDDD_DDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeroes", test_num);
            forward = 2'b00;
            databus = 32'h0;
            ALUresult = 32'h0;
            Memaddr = 32'h0;
            writedata = 32'h0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            forward = 2'b01;
            databus = 32'hFFFF_FFFF;
            ALUresult = 32'hFFFF_FFFF;
            Memaddr = 32'hFFFF_FFFF;
            writedata = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
