`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address1;
    reg [7:0] address2;
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg read1;
    reg read2;
    reg reset;
    reg write1;
    reg write2;
    wire [7:0] data_out1;
    wire [7:0] data_out2;
    wire transfer_complete1;
    wire transfer_complete2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .address1(address1),
        .address2(address2),
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .read1(read1),
        .read2(read2),
        .reset(reset),
        .write1(write1),
        .write2(write2),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .transfer_complete1(transfer_complete1),
        .transfer_complete2(transfer_complete2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address1 = 8'h0;
            address2 = 8'h0;
            data_in1 = 8'h0;
            data_in2 = 8'h0;
            read1 = 0;
            read2 = 0;
            write1 = 0;
            write2 = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Basic Write Transfer Channel 1", test_num);

            address1 = 8'h10;
            data_in1 = 8'hAA;
            write1 = 1;


            wait(transfer_complete1 == 1);
            @(posedge clk);
            write1 = 0;

            #1;


            check_outputs(8'hAA, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Basic Write Transfer Channel 2", test_num);

            address2 = 8'h20;
            data_in2 = 8'hBB;
            write2 = 1;


            wait(transfer_complete2 == 1);
            @(posedge clk);
            write2 = 0;

            #1;


            check_outputs(8'h00, 8'hBB, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Simultaneous Requests Priority Test", test_num);

            address1 = 8'h11;
            data_in1 = 8'h11;
            write1 = 1;

            address2 = 8'h22;
            data_in2 = 8'h22;
            write2 = 1;


            wait(transfer_complete1 == 1 && transfer_complete2 == 1);
            @(posedge clk);
            write1 = 0;
            write2 = 0;

            #1;


            check_outputs(8'h11, 8'h22, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Basic Read Transfer Channel 1", test_num);

            address1 = 8'h30;
            read1 = 1;


            wait(transfer_complete1 == 1);
            @(posedge clk);
            read1 = 0;



            #1;




            check_outputs(data_out1, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Sequential Dependency (Ch2 then Ch1)", test_num);


            address2 = 8'h40;
            data_in2 = 8'hCC;
            write2 = 1;


            #5;
            address1 = 8'h50;
            data_in1 = 8'hDD;
            write1 = 1;


            wait(transfer_complete1 == 1 && transfer_complete2 == 1);
            @(posedge clk);
            write1 = 0;
            write2 = 0;

            #1;


            check_outputs(8'hDD, 8'hCC, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Reset during operation", test_num);

            write1 = 1;
            address1 = 8'hFF;
            #15;

            reset = 1;
            #20;
            reset = 0;


            #1;



            check_outputs(8'h00, 8'h00, 1'b0, 1'b0);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        input expected_transfer_complete1;
        input expected_transfer_complete2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_transfer_complete1 === (expected_transfer_complete1 ^ transfer_complete1 ^ expected_transfer_complete1) &&
                expected_transfer_complete2 === (expected_transfer_complete2 ^ transfer_complete2 ^ expected_transfer_complete2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, transfer_complete1=%b, transfer_complete2=%b",
                         data_out1, data_out2, transfer_complete1, transfer_complete2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, transfer_complete1=%b, transfer_complete2=%b",
                         expected_data_out1, expected_data_out2, expected_transfer_complete1, expected_transfer_complete2);
                $display("  Got:      data_out1=%h, data_out2=%h, transfer_complete1=%b, transfer_complete2=%b",
                         data_out1, data_out2, transfer_complete1, transfer_complete2);
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
        $dumpvars(0,address1, address2, clk, data_in1, data_in2, read1, read2, reset, write1, write2, data_out1, data_out2, transfer_complete1, transfer_complete2);
    end

endmodule
