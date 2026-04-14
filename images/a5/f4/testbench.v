`timescale 1ns/1ps

module register_32bit_sync_rst_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load_en;
    reg rst;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_32bit_sync_rst dut (
        .clk(clk),
        .data_in(data_in),
        .load_en(load_en),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            load_en = 0;
            data_in = 32'h0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Load Operation", test_num);
            reset_dut();

            @(posedge clk);
            load_en = 1;
            data_in = 32'hDEADBEEF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Enable Inactive", test_num);
            reset_dut();


            @(posedge clk);
            load_en = 1;
            data_in = 32'hAAAA_5555;


            @(posedge clk);
            load_en = 0;
            data_in = 32'hFFFF_FFFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Synchronous Reset Priority", test_num);
            reset_dut();

            @(posedge clk);
            rst = 1;
            load_en = 1;
            data_in = 32'h1234_5678;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Successive Loads", test_num);
            reset_dut();

            @(posedge clk);
            load_en = 1;
            data_in = 32'h1111_1111;
            @(posedge clk);
            data_in = 32'h2222_2222;
            @(posedge clk);
            data_in = 32'h3333_3333;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: All Bits High Load", test_num);
            reset_dut();

            @(posedge clk);
            load_en = 1;
            data_in = 32'hFFFF_FFFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_32bit_sync_rst Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,clk, data_in, load_en, rst, data_out);
    end

endmodule
