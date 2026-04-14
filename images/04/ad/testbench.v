`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_16bit dut (
        .address(address),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at Address 0x0", test_num);

            address = 4'h0;
            data_in = 16'hAAAA;
            write_enable = 1'b1;
            #10;

            write_enable = 1'b0;
            #10;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read at Address 0xF", test_num);

            address = 4'hF;
            data_in = 16'h5555;
            write_enable = 1'b1;
            #10;

            write_enable = 1'b0;
            #10;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overwriting data at Address 0x7", test_num);

            address = 4'h7;
            data_in = 16'h1234;
            write_enable = 1'b1;
            #10;

            data_in = 16'hABCD;
            #10;

            write_enable = 1'b0;
            #10;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying data persistence at Address 0x0", test_num);

            address = 4'h0;
            write_enable = 1'b0;
            #10;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write all 1s to Address 0x8", test_num);
            address = 4'h8;
            data_in = 16'hFFFF;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Write all 0s to Address 0x4", test_num);
            address = 4'h4;
            data_in = 16'h0000;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Ensure Write Enable inhibits writing when low", test_num);

            address = 4'hA;
            data_in = 16'hEEEE;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;
            data_in = 16'h1111;
            #10;

            #1;


            check_outputs(16'hEEEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_data_out;
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
