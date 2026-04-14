`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg rst;
    wire [7:0] instruction_out;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .instruction_out(instruction_out),
        .stall(stall)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 8'h00;
            test_num = test_num + 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Linear Pipeline Flow...");
            reset_dut();


            instruction_in = 8'hA1; @(posedge clk);

            instruction_in = 8'hB2; @(posedge clk);

            instruction_in = 8'hC3; @(posedge clk);

            instruction_in = 8'hD4; @(posedge clk);

            instruction_in = 8'hE5; @(posedge clk);



            #1;




            check_outputs(8'hA1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Data Hazard Stall...");
            reset_dut();


            instruction_in = 8'h01; @(posedge clk);


            instruction_in = 8'h11; @(posedge clk);



            instruction_in = 8'h22;


            #2;
            if (stall === 1'b1) begin
                $display("  Success: Stall detected at Cycle 3");
            end


            @(posedge clk);



            @(posedge clk);


            #1;



            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Reset during Stall...");
            reset_dut();


            instruction_in = 8'h01; @(posedge clk);
            instruction_in = 8'h11; @(posedge clk);
            instruction_in = 8'h22;
            #2;

            if (stall === 1'b1) begin
                $display("  Hazard active, triggering reset...");
                rst = 1;
                @(posedge clk);
                #1 rst = 0;

                #1;


                check_outputs(8'h00, 1'b0);
            end else begin
                $display("  Warning: Hazard not detected as expected");
                #1;

                check_outputs(8'h00, 1'b0);
            end
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Post-Stall Instruction Propagation...");
            reset_dut();

            instruction_in = 8'h01; @(posedge clk);
            instruction_in = 8'h11; @(posedge clk);
            instruction_in = 8'hAA; @(posedge clk);



            repeat(4) @(posedge clk);


            #1;



            check_outputs(8'h11, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_instruction_out;
        input expected_stall;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h, stall=%b",
                         instruction_out, stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h, stall=%b",
                         expected_instruction_out, expected_stall);
                $display("  Got:      instruction_out=%h, stall=%b",
                         instruction_out, stall);
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
        $dumpvars(0,clk, instruction_in, rst, instruction_out, stall);
    end

endmodule
