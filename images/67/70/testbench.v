`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUresult;
    reg [31:0] Databus;
    reg [1:0] forward;
    reg [31:0] writedata;
    wire [31:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUresult(ALUresult),
        .Databus(Databus),
        .forward(forward),
        .writedata(writedata),
        .data(data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select Databus (forward = 00)", test_num);
            Databus   = 32'hAAAAAAAA;
            writedata = 32'hBBBBBBBB;
            ALUresult = 32'hCCCCCCCC;
            forward   = 2'b00;
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select writedata (forward = 01)", test_num);
            Databus   = 32'h11111111;
            writedata = 32'h22222222;
            ALUresult = 32'h33333333;
            forward   = 2'b01;
            #1;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select ALUresult (forward = 10)", test_num);
            Databus   = 32'hDEADBEEF;
            writedata = 32'hCAFEBABE;
            ALUresult = 32'h01234567;
            forward   = 2'b10;
            #1;
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select ALUresult (forward = 11)", test_num);
            Databus   = 32'hFFFFFFFF;
            writedata = 32'h00000000;
            ALUresult = 32'h55555555;
            forward   = 2'b11;
            #1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Change control while data is stable", test_num);
            Databus   = 32'hA5A5A5A5;
            writedata = 32'h5A5A5A5A;
            ALUresult = 32'hBCBCBCBC;

            forward   = 2'b00;
            #5;
            forward   = 2'b01;
            #1;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Random pattern check", test_num);
            Databus   = 32'h87654321;
            writedata = 32'h12345678;
            ALUresult = 32'hABCDEF01;
            forward   = 2'b10;
            #1;
            #1;

            check_outputs(32'hABCDEF01);
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
        input [31:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
