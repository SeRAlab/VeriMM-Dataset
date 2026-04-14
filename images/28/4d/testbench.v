`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg [15:0] data_in;
    reg re;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 4'h0;
            data_in = 16'h0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();
            addr = 4'h0;
            data_in = 16'hABCD;
            we = 1;
            #10;
            we = 0;
            #5;
            wait(re == 1);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (Addr 15)", test_num);
            reset_dut();
            addr = 4'hF;
            data_in = 16'hFFFF;
            we = 1;
            #10;
            we = 0;
            #5;
            wait(re == 1);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite existing data", test_num);
            reset_dut();
            addr = 4'h5;
            data_in = 16'h1111;
            we = 1; #10;
            data_in = 16'h2222;
            we = 1; #10;
            we = 0;
            #5;
            wait(re == 1);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation", test_num);
            reset_dut();

            addr = 4'h2; data_in = 16'h5555; we = 1; #10;

            addr = 4'h3; data_in = 16'hAAAA; we = 1; #10;
            we = 0;

            addr = 4'h2;
            #5;
            wait(re == 1);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable inactive check", test_num);
            reset_dut();
            addr = 4'h8;
            data_in = 16'h1234;
            we = 0;
            #10;
            wait(re == 1);
            #1;


            if (data_out === 16'h1234) begin
                $display("FAIL: Data written while we was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Data not written while we was low");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence", test_num);
            reset_dut();
            addr = 4'hC;
            data_in = 16'hDEAD;
            we = 1; #10;
            we = 0;
            #50;
            addr = 4'hC;
            wait(re == 1);
            #1;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_data_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,addr, data_in, re, we, data_out);
    end

endmodule
