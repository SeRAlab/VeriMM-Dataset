`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg enable;
    reg rst;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .rst(rst),
        .checksum(checksum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Checking Reset state (Output clear)", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Single word (0x0001)", test_num);
            reset_dut();
            data_in = 16'h0001;
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Simple accumulation no carry (0x1234 + 0x5678)", test_num);
            reset_dut();
            enable = 1;
            data_in = 16'h1234;
            @(posedge clk);
            data_in = 16'h5678;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(16'h9753);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: End-around carry (0x8000 + 0x8000)", test_num);
            reset_dut();
            enable = 1;
            data_in = 16'h8000;
            @(posedge clk);
            data_in = 16'h8000;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Max values (0xFFFF + 0xFFFF)", test_num);
            reset_dut();
            enable = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'hFFFF;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Multi-word carry (0xF000, 0xF000, 0x3000)", test_num);
            reset_dut();
            enable = 1;
            data_in = 16'hF000;
            @(posedge clk);
            data_in = 16'hF000;
            @(posedge clk);
            data_in = 16'h3000;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(16'hEFFD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Zero inputs (0x0000 + 0x0000)", test_num);
            reset_dut();
            enable = 1;
            data_in = 16'h0000;
            @(posedge clk);
            data_in = 16'h0000;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Enable gating check", test_num);
            reset_dut();
            enable = 1;
            data_in = 16'h1111;
            @(posedge clk);
            enable = 0;
            data_in = 16'hEEEE;
            @(posedge clk);
            #1;
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
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
        $dumpvars(0,clk, data_in, enable, rst, checksum);
    end

endmodule
