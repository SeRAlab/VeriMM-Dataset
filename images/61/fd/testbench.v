`timescale 1ns/1ps

module reg_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg reset;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
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
            reset = 1;
            enable = 0;
            data_in = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify Data Load (Enable=1)", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1;
            data_in = 32'hABCD1234;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Data Retention (Enable=0)", test_num);
            reset_dut();


            @(posedge clk);
            enable = 1;
            data_in = 32'h5555AAAA;
            @(posedge clk);


            enable = 0;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify Reset Priority over Enable", test_num);
            reset_dut();


            @(posedge clk);
            enable = 1;
            data_in = 32'h12345678;
            @(posedge clk);


            reset = 1;
            enable = 1;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify All-Ones Pattern", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);

            enable = 1;
            data_in = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Writes", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1;
            data_in = 32'h11111111;
            @(posedge clk);
            data_in = 32'h22222222;
            @(posedge clk);
            data_in = 32'h33333333;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h33333333);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_32bit Testbench");
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
        $dumpvars(0,clk, data_in, enable, reset, data_out);
    end

endmodule
