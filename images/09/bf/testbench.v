`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg [15:0] data_in;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

        begin
            addr = 4'h0;
            data_in = 16'h0000;


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write/Read - Address 0", test_num);
            reset_dut();
            addr = 4'h0;
            data_in = 16'hA5A5;
            #20;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write/Read - Address 15", test_num);
            reset_dut();
            addr = 4'hF;
            data_in = 16'h5A5A;
            #20;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwriting Data - Address 7", test_num);
            reset_dut();
            addr = 4'h7;
            data_in = 16'h1111;
            #20;
            data_in = 16'h2222;
            #20;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address Isolation", test_num);
            reset_dut();

            addr = 4'h2; data_in = 16'hBEEF; #20;

            addr = 4'h3; data_in = 16'hDEAD; #20;

            addr = 4'h2;
            #20;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case Data (All 0s and 1s)", test_num);
            reset_dut();

            addr = 4'h4; data_in = 16'hFFFF; #20;
            #1;

            check_outputs(16'hFFFF);


            addr = 4'h5; data_in = 16'h0000; #20;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Read/Write Stress", test_num);
            reset_dut();

            addr = 4'hA; data_in = 16'hCAFE; #20;
            addr = 4'hB; data_in = 16'hBABE; #20;
            addr = 4'hC; data_in = 16'hFACE; #20;


            addr = 4'hB;
            #20;
            #1;

            check_outputs(16'hBABE);
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
        $dumpvars(0,addr, data_in, write_enable, data_out);
    end

endmodule
