`timescale 1ns/1ps

module md5_transform_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst_n;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_transform dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros Input", test_num);
            reset_dut();
            data_in = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'h00000000));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Ones Input", test_num);
            reset_dut();
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'hFFFFFFFF));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Alternating Bits (AAAA_AAAA)", test_num);
            reset_dut();
            data_in = 32'hAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'hAAAAAAAA));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating Bits (5555_5555)", test_num);
            reset_dut();
            data_in = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'h55555555));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Arbitrary Pattern (1234_5678)", test_num);
            reset_dut();
            data_in = 32'h12345678;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'h12345678));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Boundary Check", test_num);
            reset_dut();

            data_in = 32'hF0000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'hF0000000));
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Single Bit Set (MSB)", test_num);
            reset_dut();
            data_in = 32'h80000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(md5_model(32'h80000000));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_transform Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst_n, data_out);
    end

endmodule
