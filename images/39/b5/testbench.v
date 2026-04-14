`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg flush_signal;
    reg [7:0] instruction_in;
    reg rst;
    reg stall_signal;
    wire [7:0] EX_stage;
    wire [7:0] ID_stage;
    wire [7:0] IF_stage;
    wire [7:0] MEM_stage;
    wire [7:0] WB_stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .flush_signal(flush_signal),
        .instruction_in(instruction_in),
        .rst(rst),
        .stall_signal(stall_signal),
        .EX_stage(EX_stage),
        .ID_stage(ID_stage),
        .IF_stage(IF_stage),
        .MEM_stage(MEM_stage),
        .WB_stage(WB_stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stall_signal = 0;
            flush_signal = 0;
            instruction_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Normal Propagation", test_num);
            reset_dut();


            instruction_in = 8'hA1; @(posedge clk);
            instruction_in = 8'hB2; @(posedge clk);
            instruction_in = 8'hC3; @(posedge clk);
            instruction_in = 8'hD4; @(posedge clk);
            instruction_in = 8'hE5; @(posedge clk);
            #1;



            #1;




            check_outputs(8'hC3, 8'hD4, 8'hE5, 8'hB2, 8'hA1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Stall Functionality", test_num);
            reset_dut();


            instruction_in = 8'h11; @(posedge clk);
            instruction_in = 8'h22; @(posedge clk);


            stall_signal = 1;
            instruction_in = 8'h33; @(posedge clk);
            instruction_in = 8'h44; @(posedge clk);


            stall_signal = 0;
            @(posedge clk);
            #1;







            #1;








            check_outputs(8'h11, 8'h22, 8'h33, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Flush Functionality", test_num);
            reset_dut();


            instruction_in = 8'hAA; @(posedge clk);
            instruction_in = 8'hBB; @(posedge clk);
            instruction_in = 8'hCC; @(posedge clk);


            flush_signal = 1;
            @(posedge clk);


            flush_signal = 0;
            instruction_in = 8'hDD; @(posedge clk);
            #1;





            #1;






            check_outputs(8'h00, 8'h00, 8'hDD, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Full Pipeline Flow Through", test_num);
            reset_dut();


            instruction_in = 8'hFF; @(posedge clk);
            instruction_in = 8'h00; @(posedge clk);
            instruction_in = 8'h00; @(posedge clk);
            instruction_in = 8'h00; @(posedge clk);
            instruction_in = 8'h00; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Simultaneous Stall and Flush", test_num);
            reset_dut();

            instruction_in = 8'h10; @(posedge clk);
            instruction_in = 8'h20; @(posedge clk);


            stall_signal = 1;
            flush_signal = 1;
            @(posedge clk);

            stall_signal = 0;
            flush_signal = 0;
            #1;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [7:0] expected_EX_stage;
        input [7:0] expected_ID_stage;
        input [7:0] expected_IF_stage;
        input [7:0] expected_MEM_stage;
        input [7:0] expected_WB_stage;
        begin
            if (expected_EX_stage === (expected_EX_stage ^ EX_stage ^ expected_EX_stage) &&
                expected_ID_stage === (expected_ID_stage ^ ID_stage ^ expected_ID_stage) &&
                expected_IF_stage === (expected_IF_stage ^ IF_stage ^ expected_IF_stage) &&
                expected_MEM_stage === (expected_MEM_stage ^ MEM_stage ^ expected_MEM_stage) &&
                expected_WB_stage === (expected_WB_stage ^ WB_stage ^ expected_WB_stage)) begin
                $display("PASS");
                $display("  Outputs: EX_stage=%h, ID_stage=%h, IF_stage=%h, MEM_stage=%h, WB_stage=%h",
                         EX_stage, ID_stage, IF_stage, MEM_stage, WB_stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_stage=%h, ID_stage=%h, IF_stage=%h, MEM_stage=%h, WB_stage=%h",
                         expected_EX_stage, expected_ID_stage, expected_IF_stage, expected_MEM_stage, expected_WB_stage);
                $display("  Got:      EX_stage=%h, ID_stage=%h, IF_stage=%h, MEM_stage=%h, WB_stage=%h",
                         EX_stage, ID_stage, IF_stage, MEM_stage, WB_stage);
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
        $dumpvars(0,clk, flush_signal, instruction_in, rst, stall_signal, EX_stage, ID_stage, IF_stage, MEM_stage, WB_stage);
    end

endmodule
