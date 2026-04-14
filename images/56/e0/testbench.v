`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg en;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
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
            rst <= 1;
            en <= 0;
            data_in <= 0;
            @(posedge clk);
            rst <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift 8 bits (Pattern 10101010)", test_num);
            reset_dut();
            en <= 1;



            repeat(4) begin
                data_in <= 1; @(posedge clk);
                data_in <= 0; @(posedge clk);
            end
            en <= 0;
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Signal Control", test_num);
            reset_dut();
            en <= 1;
            data_in <= 1; @(posedge clk);
            data_in <= 1; @(posedge clk);
            en <= 0;
            data_in <= 0; repeat(4) @(posedge clk);
            en <= 1;
            data_in <= 0; @(posedge clk);
            en <= 0;
            #1 #1;
 check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill Register with 1s", test_num);
            reset_dut();
            en <= 1;
            data_in <= 1;
            repeat(8) @(posedge clk);
            en <= 0;
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift and Overflow (Total 10 shifts)", test_num);
            reset_dut();
            en <= 1;

            repeat(4) begin
                data_in <= 0; @(posedge clk);
                data_in <= 1; @(posedge clk);
            end



            data_in <= 1;
            repeat(2) @(posedge clk);
            en <= 0;
            #1 #1;
 check_outputs(8'h57);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Enable", test_num);
            reset_dut();

            for (integer i = 0; i < 8; i = i + 1) begin
                en <= (i % 2 == 0);
                data_in <= 1;
                @(posedge clk);
            end


            en <= 0;
            #1 #1;
 check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        $dumpvars(0,clk, data_in, en, rst, data_out);
    end

endmodule
