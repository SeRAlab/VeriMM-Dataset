`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [6:0] received;
    wire [3:0] data_out;
    wire [6:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .received(received),
        .data_out(data_out),
        .encoded(encoded)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b0000 (No Error)", test_num);
        data_in = 4'b0000;
        received = 7'b0000000;
        #10;


        #1;



        check_outputs(4'b0000, 7'b0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b1111 (No Error)", test_num);
        data_in = 4'b1111;
        received = 7'b1111111;
        #10;

        #1;


        check_outputs(4'b1111, 7'b1111111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b1010 (No Error)", test_num);
        data_in = 4'b1010;
        received = 7'b1010010;
        #10;

        #1;


        check_outputs(4'b1010, 7'b1010010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b1010 (Error at Bit 6)", test_num);
        data_in = 4'b1010;

        received = 7'b0010010;
        #10;

        #1;


        check_outputs(4'b1010, 7'b1010010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b1010 (Error at Bit 0)", test_num);
        data_in = 4'b1010;

        received = 7'b1010011;
        #10;

        #1;


        check_outputs(4'b1010, 7'b1010010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b1010 (Error at Bit 3)", test_num);
        data_in = 4'b1010;

        received = 7'b1011010;
        #10;
        #1;

        check_outputs(4'b1010, 7'b1010010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b0101 (Error at Parity Bit 1)", test_num);
        data_in = 4'b0101;


        received = 7'b0101111;
        #10;

        #1;


        check_outputs(4'b0101, 7'b0101101);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data 4'b1001 (Error at Bit 5)", test_num);
        data_in = 4'b1001;


        received = 7'b1101100;
        #10;
        #1;

        check_outputs(4'b1001, 7'b1001100);
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
        input [3:0] expected_data_out;
        input [6:0] expected_encoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, encoded=%h",
                         data_out, encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, encoded=%h",
                         expected_data_out, expected_encoded);
                $display("  Got:      data_out=%h, encoded=%h",
                         data_out, encoded);
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
