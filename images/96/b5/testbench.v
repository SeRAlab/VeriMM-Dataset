`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] addr;
    reg [1:0] datamode;
    reg write;
    wire [7:0] we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .datamode(datamode),
        .write(write),
        .we(we)
    );
    task testcase001;

        begin
            $display("Testcase 001: Write disabled");
            test_num = test_num + 1;
            write = 0; datamode = 2'b11; addr = 3'b000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Byte write at offset 0");
            test_num = test_num + 1;
            write = 1; datamode = 2'b00; addr = 3'b000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Byte write at offset 3");
            test_num = test_num + 1;
            write = 1; datamode = 2'b00; addr = 3'b011;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Byte write at offset 7");
            test_num = test_num + 1;
            write = 1; datamode = 2'b00; addr = 3'b111;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Half-word write at offset 0");
            test_num = test_num + 1;
            write = 1; datamode = 2'b01; addr = 3'b000;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Half-word write at offset 2");
            test_num = test_num + 1;
            write = 1; datamode = 2'b01; addr = 3'b010;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Half-word write at offset 4");
            test_num = test_num + 1;
            write = 1; datamode = 2'b01; addr = 3'b100;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Half-word write at offset 6");
            test_num = test_num + 1;
            write = 1; datamode = 2'b01; addr = 3'b110;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Word write at offset 0");
            test_num = test_num + 1;
            write = 1; datamode = 2'b10; addr = 3'b000;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Word write at offset 4");
            test_num = test_num + 1;
            write = 1; datamode = 2'b10; addr = 3'b100;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Double-word write");
            test_num = test_num + 1;
            write = 1; datamode = 2'b11; addr = 3'b000;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Double-word write with non-zero addr (should ignore alignment)");
            test_num = test_num + 1;
            write = 1; datamode = 2'b11; addr = 3'b101;
            #1;

            check_outputs(8'hFF);
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: we=%h",
                         we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: we=%h",
                         expected_we);
                $display("  Got:      we=%h",
                         we);
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
