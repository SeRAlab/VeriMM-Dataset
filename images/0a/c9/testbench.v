`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [3:0] req;
    reg rst;
    wire active;
    wire [1:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack(ack),
        .clk(clk),
        .req(req),
        .rst(rst),
        .active(active),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            ack = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Channel 0 Single Request", test_num);
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Channel 1 Single Request", test_num);
            reset_dut();
            req = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Channel 2 Single Request", test_num);
            reset_dut();
            req = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Channel 3 Single Request", test_num);
            reset_dut();
            req = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Priority Check (0 vs 3)", test_num);
            reset_dut();
            req = 4'b1001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Priority Check (1 vs 2)", test_num);
            reset_dut();
            req = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %03d: All channels requesting", test_num);
            reset_dut();
            req = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Idle transition", test_num);
            reset_dut();
            req = 4'b0010;
            @(posedge clk);
            req = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Handshake Ack Input", test_num);
            reset_dut();
            req = 4'b0100;
            ack = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_active;
        input [1:0] expected_sel;
        begin
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: active=%b, sel=%h",
                         active, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, sel=%h",
                         expected_active, expected_sel);
                $display("  Got:      active=%b, sel=%h",
                         active, sel);
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
        $dumpvars(0,ack, clk, req, rst, active, sel);
    end

endmodule
