`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg clk;
    reg [7:0] data_in;
    reg request;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .request(request),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            request <= 1'b0;
            address <= 3'b0;
            data_in <= 8'b0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Write 0xA5 to Addr 0 and Read back", test_num);
            reset_dut();


            address = 3'd0;
            data_in = 8'hA5;
            request = 1'b1;
            @(posedge clk);
            wait(done == 1'b1);
            @(posedge clk);
            request = 1'b0;
            repeat (2) @(posedge clk);


            address = 3'd0;
            request = 1'b1;
            @(posedge clk);
            wait(done == 1'b1);


            #1;



            check_outputs(8'hA5, 1'b1);

            @(posedge clk);
            request = 1'b0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Write 0x5A to Addr 7 and Read back", test_num);
            reset_dut();


            address = 3'd7;
            data_in = 8'h5A;
            request = 1'b1;
            @(posedge clk);
            wait(done == 1'b1);
            @(posedge clk);
            request = 1'b0;
            repeat (2) @(posedge clk);


            address = 3'd7;
            request = 1'b1;
            @(posedge clk);
            wait(done == 1'b1);


            #1;



            check_outputs(8'h5A, 1'b1);

            @(posedge clk);
            request = 1'b0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Overwrite Addr 3 (0x11 then 0xEE)", test_num);
            reset_dut();


            address = 3'd3; data_in = 8'h11; request = 1'b1;
            @(posedge clk); wait(done); @(posedge clk); request = 1'b0;
            repeat (2) @(posedge clk);


            address = 3'd3; data_in = 8'hEE; request = 1'b1;
            @(posedge clk); wait(done); @(posedge clk); request = 1'b0;
            repeat (2) @(posedge clk);


            address = 3'd3; request = 1'b1;
            @(posedge clk); wait(done == 1'b1);


            #1;



            check_outputs(8'hEE, 1'b1);

            @(posedge clk);
            request = 1'b0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Write Addr 4 and 5, verify Addr 4", test_num);
            reset_dut();


            address = 3'd4; data_in = 8'h44; request = 1'b1;
            @(posedge clk); wait(done); @(posedge clk); request = 1'b0;


            address = 3'd5; data_in = 8'h55; request = 1'b1;
            @(posedge clk); wait(done); @(posedge clk); request = 1'b0;


            address = 3'd4; request = 1'b1;
            @(posedge clk); wait(done == 1'b1);


            #1;



            check_outputs(8'h44, 1'b1);

            @(posedge clk);
            request = 1'b0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Read uninitialized Addr 2", test_num);
            reset_dut();


            address = 3'd2;
            request = 1'b1;
            @(posedge clk);
            wait(done == 1'b1);


            #1;



            check_outputs(8'h00, 1'b1);

            @(posedge clk);
            request = 1'b0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,address, clk, data_in, request, data_out, done);
    end

endmodule
