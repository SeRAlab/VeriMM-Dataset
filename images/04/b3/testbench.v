`timescale 1ns/1ps

module simple_des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [2:0] key;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des_encryption dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 8'h00;
            key = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: All zeros input, key=000", test_num);
            data_in = 8'h00;
            key = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: All ones input, key=000", test_num);
            data_in = 8'hFF;
            key = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: All zeros input, key=111", test_num);
            data_in = 8'h00;
            key = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: data=0x55, key=010", test_num);
            data_in = 8'h55;
            key = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: data=0xAA, key=101", test_num);
            data_in = 8'hAA;
            key = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: data=0x00, key=010", test_num);
            data_in = 8'h00;
            key = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h92);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: data=0x00, key=101", test_num);
            data_in = 8'h00;
            key = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h6D);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: data=0xFF, key=111", test_num);
            data_in = 8'hFF;
            key = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: data=0xC3, key=011", test_num);
            data_in = 8'hC3;
            key = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h18);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: data=0xF0, key=100", test_num);
            data_in = 8'hF0;
            key = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des_encryption Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,clk, data_in, key, data_out);
    end

endmodule
