`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    wire done;
    wire serialized_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .done(done),
        .serialized_out(serialized_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones (32'hFFFFFFFF)", test_num);
            data_in = 32'hFFFF_FFFF;
            reset_dut();


            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end


            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros (32'h00000000)", test_num);
            data_in = 32'h0000_0000;
            reset_dut();

            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end


            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bits (32'hAAAA_AAAA)", test_num);

            data_in = 32'hAAAA_AAAA;
            reset_dut();

            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end


            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bits (32'h5555_5555)", test_num);

            data_in = 32'h5555_5555;
            reset_dut();

            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end


            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Boundary Bits (32'h8000_0001)", test_num);
            data_in = 32'h8000_0001;
            reset_dut();

            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end


            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        input expected_done;
        input expected_serialized_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_serialized_out === (expected_serialized_out ^ serialized_out ^ expected_serialized_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, serialized_out=%b",
                         done, serialized_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, serialized_out=%b",
                         expected_done, expected_serialized_out);
                $display("  Got:      done=%b, serialized_out=%b",
                         done, serialized_out);
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
        $dumpvars(0,clk, data_in, reset, done, serialized_out);
    end

endmodule
