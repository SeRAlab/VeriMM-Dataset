`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    reg [7:0] dest_addr;
    reg rst;
    reg [7:0] src_addr;
    wire [7:0] data_out;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .control(control),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
        .data_out(data_out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control = 2'b00;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 0 Transfer", test_num);
            reset_dut();

            control = 2'b00;
            src_addr = 8'hAA;
            dest_addr = 8'h11;



            @(posedge clk);
            wait(status == 1'b1);



            #1;




            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Transfer", test_num);
            reset_dut();

            control = 2'b01;
            src_addr = 8'hBB;
            dest_addr = 8'h22;

            @(posedge clk);
            wait(status == 1'b1);

            #1;


            check_outputs(8'hBB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 2 Transfer", test_num);
            reset_dut();

            control = 2'b10;
            src_addr = 8'hCC;
            dest_addr = 8'h33;

            @(posedge clk);
            wait(status == 1'b1);

            #1;


            check_outputs(8'hCC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 3 Transfer", test_num);
            reset_dut();

            control = 2'b11;
            src_addr = 8'hDD;
            dest_addr = 8'h44;

            @(posedge clk);
            wait(status == 1'b1);

            #1;


            check_outputs(8'hDD, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Post-Reset State Check", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Address Values", test_num);
            reset_dut();

            control = 2'b00;
            src_addr = 8'hFF;
            dest_addr = 8'hFF;

            @(posedge clk);
            wait(status == 1'b1);

            #1;


            check_outputs(8'hFF, 1'b1);
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
        input expected_status;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, status=%b",
                         data_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, status=%b",
                         expected_data_out, expected_status);
                $display("  Got:      data_out=%h, status=%b",
                         data_out, status);
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
        $dumpvars(0,clk, control, dest_addr, rst, src_addr, data_out, status);
    end

endmodule
