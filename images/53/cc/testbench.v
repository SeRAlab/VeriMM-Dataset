`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] addr1;
    reg [4:0] addr2;
    reg [4:0] writeAddr;
    reg [31:0] writeData;
    reg writeEn;
    wire [31:0] dataOut1;
    wire [31:0] dataOut2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .writeAddr(writeAddr),
        .writeData(writeData),
        .writeEn(writeEn),
        .dataOut1(dataOut1),
        .dataOut2(dataOut2)
    );
    task reset_signals;

        begin
            addr1 = 0;
            addr2 = 0;
            writeAddr = 0;
            writeData = 0;
            writeEn = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (Port 1)", test_num);
            reset_signals();


            writeAddr = 5'd5;
            writeData = 32'h12345678;
            writeEn = 1;
            #10;
            writeEn = 0;


            addr1 = 5'd5;
            addr2 = 5'd0;
            #1;

            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dual Port Read Access", test_num);
            reset_signals();


            writeAddr = 5'd10;
            writeData = 32'hAAAAAAAA;
            writeEn = 1;
            #10;


            writeAddr = 5'd20;
            writeData = 32'h55555555;
            writeEn = 1;
            #10;
            writeEn = 0;


            addr1 = 5'd10;
            addr2 = 5'd20;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable (writeEn) Functional Check", test_num);
            reset_signals();


            writeAddr = 5'd15;
            writeData = 32'hFFFFFFFF;
            writeEn = 1;
            #10;


            writeAddr = 5'd15;
            writeData = 32'h00000000;
            writeEn = 0;
            #10;


            addr1 = 5'd15;
            addr2 = 5'd15;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Register Check (Reg 31)", test_num);
            reset_signals();


            writeAddr = 5'd31;
            writeData = 32'hBCDEBCDE;
            writeEn = 1;
            #10;
            writeEn = 0;

            addr1 = 5'd31;
            addr2 = 5'd0;
            #1;

            check_outputs(32'hBCDEBCDE, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Existing Data", test_num);
            reset_signals();


            writeAddr = 5'd7;
            writeData = 32'h11111111;
            writeEn = 1;
            #10;


            writeData = 32'h22222222;
            #10;
            writeEn = 0;

            addr1 = 5'd7;
            addr2 = 5'd7;
            #1;

            check_outputs(32'h22222222, 32'h22222222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read-While-Write Logic Check", test_num);
            reset_signals();


            addr1 = 5'd12;
            addr2 = 5'd0;


            writeAddr = 5'd12;
            writeData = 32'h99887766;
            writeEn = 1;
            #10;


            #1;



            check_outputs(32'h99887766, 32'h0);
            writeEn = 0;
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
        input [31:0] expected_dataOut1;
        input [31:0] expected_dataOut2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataOut1 === (expected_dataOut1 ^ dataOut1 ^ expected_dataOut1) &&
                expected_dataOut2 === (expected_dataOut2 ^ dataOut2 ^ expected_dataOut2)) begin
                $display("PASS");
                $display("  Outputs: dataOut1=%h, dataOut2=%h",
                         dataOut1, dataOut2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut1=%h, dataOut2=%h",
                         expected_dataOut1, expected_dataOut2);
                $display("  Got:      dataOut1=%h, dataOut2=%h",
                         dataOut1, dataOut2);
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
