`timescale 1ns/1ps

module aes_sbox_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_sbox dut (
        .clk(clk),
        .data_in(data_in),
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
            rst = 1;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 00h", test_num);
            #1;

            check_outputs(8'h63);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'h01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 01h", test_num);
            #1;

            check_outputs(8'h7c);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'h10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 10h", test_num);
            #1;

            check_outputs(8'hca);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'h53;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 53h", test_num);
            #1;

            check_outputs(8'hed);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'h7b;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 7Bh", test_num);
            #1;

            check_outputs(8'h21);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'had;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input ADh", test_num);
            #1;

            check_outputs(8'h95);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'hfe;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input FEh", test_num);
            #1;

            check_outputs(8'hbb);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 8'hff;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input FFh", test_num);
            #1;

            check_outputs(8'h16);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_sbox Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
