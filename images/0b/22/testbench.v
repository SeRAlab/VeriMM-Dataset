`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Pass-through Mode (Control 000)");
            control = 3'b000;
            data_in = 32'hDEADBEEF;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Bitwise Inversion (Control 001)");
            control = 3'b001;
            data_in = 32'h0000FFFF;

            #1;


            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Byte Swap (Control 010)");
            control = 3'b010;
            data_in = 32'h11223344;

            #1;


            check_outputs(32'h44332211);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: XOR Scrambling (Control 011)");
            control = 3'b011;
            data_in = 32'hAAAAAAAA;

            #1;


            check_outputs(32'h0F0F0F0F);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Nibble Left Shift (Control 100)");
            control = 3'b100;
            data_in = 32'h0000000F;

            #1;


            check_outputs(32'h000000F0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Header Insertion (Control 101)");
            control = 3'b101;
            data_in = 32'h00001234;

            #1;


            check_outputs(32'h80001234);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Bit Reversal (Control 110)");
            control = 3'b110;
            data_in = 32'hF0000000;

            #1;


            check_outputs(32'h0000000F);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Nullify Data (Control 111)");
            control = 3'b111;
            data_in = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
