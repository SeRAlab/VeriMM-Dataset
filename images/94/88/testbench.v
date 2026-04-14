`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg A5;
    reg D0;
    reg D1;
    reg WCLK;
    reg WE;
    wire O0;
    wire O1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .A5(A5),
        .D0(D0),
        .D1(D1),
        .WCLK(WCLK),
        .WE(WE),
        .O0(O0),
        .O1(O1)
    );

        task reset_dut;

        begin
            WCLK = 0;
            WE = 0;
            set_address(6'b0);
            set_data(2'b0);
            #10;
        end
        endtask
    task set_address;

        input [5:0] addr;
        begin
            A5 = addr[5];
            A4 = addr[4];
            A3 = addr[3];
            A2 = addr[2];
            A1 = addr[1];
            A0 = addr[0];
        end
        endtask

    task set_data;

        input [1:0] data;
        begin
            D1 = data[1];
            D0 = data[0];
        end
        endtask

    task write_cycle;

        input [5:0] addr;
        input [1:0] data;
        begin
            WE = 1;
            set_address(addr);
            set_data(data);
            #5 WCLK = 1;
            #5 WCLK = 0;
            WE = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write/Read Addr 0", test_num);
            reset_dut();
            write_cycle(6'd0, 2'b10);
            set_address(6'd0);
            #5;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write/Read Addr 63", test_num);
            reset_dut();
            write_cycle(6'd63, 2'b01);
            set_address(6'd63);
            #5;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: WE Control Check", test_num);
            reset_dut();

            set_address(6'd10);
            set_data(2'b11);
            WE = 0;
            #5 WCLK = 1; #5 WCLK = 0;
            #5;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite Data", test_num);
            reset_dut();
            write_cycle(6'd32, 2'b11);
            write_cycle(6'd32, 2'b00);
            set_address(6'd32);
            #5;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address Isolation", test_num);
            reset_dut();
            write_cycle(6'd5, 2'b11);
            write_cycle(6'd6, 2'b00);
            set_address(6'd5);
            #5;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Line Independence", test_num);
            reset_dut();
            write_cycle(6'd15, 2'b10);
            set_address(6'd15);
            #5;
            if (O1 === 1 && O0 === 0) begin
                write_cycle(6'd15, 2'b01);
                set_address(6'd15);
                #5;
                #1;

                check_outputs(1, 0);
            end else begin
                #1;

                check_outputs(1, 0);
            end
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
        input expected_O0;
        input expected_O1;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b",
                         O0, O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b",
                         expected_O0, expected_O1);
                $display("  Got:      O0=%b, O1=%b",
                         O0, O1);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A0, A1, A2, A3, A4, A5, D0, D1, WCLK, WE, O0, O1);
    end

endmodule
