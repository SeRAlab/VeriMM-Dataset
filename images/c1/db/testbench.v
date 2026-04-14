`timescale 1ns/1ps

module mac_crc32_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] data;
    reg valid;
    wire [31:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_crc32 dut (
        .clear(clear),
        .clk(clk),
        .data(data),
        .valid(valid),
        .crc(crc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            clear = 1;
            valid = 0;
            data = 8'h00;
            @(posedge clk);
            clear = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single byte 0x00", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'h00;
            valid = 1;
            @(posedge clk);
            valid = 0;

            #1;


            check_outputs(32'h2DFD1072);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single byte 0x41 ('A')", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'h41;
            valid = 1;
            @(posedge clk);
            valid = 0;

            #1;


            check_outputs(32'h2E134D90);
        end
        endtask

    task testcase004;

        reg [7:0] test_str [0:8];
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: String '123456789'", test_num);

            test_str[0] = 8'h31; test_str[1] = 8'h32; test_str[2] = 8'h33;
            test_str[3] = 8'h34; test_str[4] = 8'h35; test_str[5] = 8'h36;
            test_str[6] = 8'h37; test_str[7] = 8'h38; test_str[8] = 8'h39;

            reset_dut();

            for (i = 0; i < 9; i = i + 1) begin
                @(posedge clk);
                data = test_str[i];
                valid = 1;
            end
            @(posedge clk);
            valid = 0;

            #1;


            check_outputs(32'hCBF43926);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid Signal Gating", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hFF;
            valid = 0;
            @(posedge clk);
            data = 8'h41;
            valid = 1;
            @(posedge clk);
            valid = 0;

            #1;


            check_outputs(32'h2E134D90);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Clears", test_num);

            @(posedge clk);
            clear = 1;
            @(posedge clk);
            @(posedge clk);
            clear = 0;

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
        $display("mac_crc32 Testbench");
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
        input [31:0] expected_crc;
        begin
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
        $dumpvars(0,clear, clk, data, valid, crc);
    end

endmodule
