`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] read_address1;
    reg [7:0] read_address2;
    reg read_enable1;
    reg read_enable2;
    reg [7:0] write_address;
    reg [7:0] write_data;
    reg write_enable;
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .read_address1(read_address1),
        .read_address2(read_address2),
        .read_enable1(read_enable1),
        .read_enable2(read_enable2),
        .write_address(write_address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Port 1 Write and Read", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;

            write_enable = 1; write_address = 8'h01; write_data = 8'hAA;
            #10;
            write_enable = 0;

            read_enable1 = 1; read_address1 = 8'h01;
            read_enable2 = 0;
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Port 2 Write and Read", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;

            write_enable = 1; write_address = 8'h02; write_data = 8'hBB;
            #10;
            write_enable = 0;

            read_enable1 = 0;
            read_enable2 = 1; read_address2 = 8'h02;
            #1;

            check_outputs(8'h00, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Simultaneous Read (Different Addresses)", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;

            write_enable = 1; write_address = 8'h01; write_data = 8'h11; #10;
            write_address = 8'h02; write_data = 8'h22; #10;
            write_enable = 0;

            read_enable1 = 1; read_address1 = 8'h01;
            read_enable2 = 1; read_address2 = 8'h02;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Simultaneous Read (Same Address)", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;

            write_enable = 1; write_address = 8'h10; write_data = 8'h55; #10;
            write_enable = 0;

            read_enable1 = 1; read_address1 = 8'h10;
            read_enable2 = 1; read_address2 = 8'h10;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Write and Read (Write-through)", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;

            write_enable = 1; write_address = 8'h30; write_data = 8'hCC;
            read_enable1 = 1; read_address1 = 8'h30;
            read_enable2 = 0;
            #1;

            check_outputs(8'hCC, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Data", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;

            write_enable = 1; write_address = 8'h40; write_data = 8'h01; #10;

            write_address = 8'h40; write_data = 8'hFF; #10;
            write_enable = 0;
            read_enable1 = 1; read_address1 = 8'h40;
            read_enable2 = 0;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (0xFF)", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;
            write_enable = 1; write_address = 8'hFF; write_data = 8'h99; #10;
            write_enable = 0;
            read_enable1 = 1; read_address1 = 8'hFF;
            read_enable2 = 1; read_address2 = 8'hFF;
            #1;

            check_outputs(8'h99, 8'h99);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Enable Logic (Port 2 Disabled)", test_num);

            write_enable = 0; write_address = 8'h00; write_data = 8'h00;
            read_enable1 = 0; read_address1 = 8'h00;
            read_enable2 = 0; read_address2 = 8'h00;
            #10;
            write_enable = 1; write_address = 8'h50; write_data = 8'h77; #10;
            write_enable = 0;
            read_enable1 = 1; read_address1 = 8'h50;
            read_enable2 = 0; read_address2 = 8'h50;
            #1;

            check_outputs(8'h77, 8'h00);
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
        input [7:0] expected_read_data1;
        input [7:0] expected_read_data2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1) &&
                expected_read_data2 === (expected_read_data2 ^ read_data2 ^ expected_read_data2)) begin
                $display("PASS");
                $display("  Outputs: read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data1=%h, read_data2=%h",
                         expected_read_data1, expected_read_data2);
                $display("  Got:      read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
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
