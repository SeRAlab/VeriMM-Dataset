`timescale 1ns/1ps

module decoder_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] address;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder dut (
        .address(address),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Address = 000");
            address = 3'b000;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Address = 001");
            address = 3'b001;
            #1;

            check_outputs(8'b0000_0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Address = 010");
            address = 3'b010;
            #1;

            check_outputs(8'b0000_0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Address = 011");
            address = 3'b011;
            #1;

            check_outputs(8'b0000_1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Address = 100");
            address = 3'b100;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Address = 101");
            address = 3'b101;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Address = 110");
            address = 3'b110;
            #1;

            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Address = 111");
            address = 3'b111;
            #1;

            check_outputs(8'b1000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder Testbench");
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
        input [7:0] expected_data_out;
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
