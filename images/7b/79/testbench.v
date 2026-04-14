`timescale 1ns/1ps

module rom_128x4_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rom_128x4 dut (
        .addr(addr),
        .clk(clk),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 7'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reading Address 0", test_num);
            reset_dut();
            addr = 7'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reading Address 1", test_num);
            reset_dut();
            addr = 7'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reading Address 64 (0x40)", test_num);
            reset_dut();
            addr = 7'd64;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reading Address 127 (0x7F)", test_num);
            reset_dut();
            addr = 7'd127;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reading Address 42 (0x2A)", test_num);
            reset_dut();
            addr = 7'd42;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Timing Verification (Synchronous Read)", test_num);
            reset_dut();
            addr = 7'd15;
            #2;


            if (read_data !== 4'h0) begin
                $display("Warning: Data changed before clock edge!");
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rom_128x4 Testbench");
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
        input [3:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,addr, clk, read_data);
    end

endmodule
