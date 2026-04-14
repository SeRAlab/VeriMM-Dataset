`timescale 1ns/1ps

module SubBytes_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg rst;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SubBytes dut (
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
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Input", test_num);
            reset_dut();
            data_in = 128'h00000000_00000000_00000000_00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h63636363_63636363_63636363_63636363);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All FF Input", test_num);
            reset_dut();
            data_in = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h16161616_16161616_16161616_16161616);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NIST Example Vector", test_num);
            reset_dut();
            data_in = 128'h193de3be_a0f4e22b_9ac8e8e8_c1599b40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'hd42711ae_e0bf98f1_b8e89b9b_78cb1409);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Byte Pattern", test_num);
            reset_dut();
            data_in = 128'h00010203_04050607_08090a0b_0c0d0e0f;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h637c777b_f26b6fc5_3001672b_fed7ab76);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Mixed Values", test_num);
            reset_dut();
            data_in = 128'h4d7ef15c_23a5e812_00ff4599_88112233;




            @(posedge clk);
            #1;
            #1;

            check_outputs(128'he3f3a14a_26069bc9_63166eee_c48293c3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SubBytes Testbench");
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
        input [127:0] expected_data_out;
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
