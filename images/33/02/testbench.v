`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] current_value;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .reset(reset),
        .current_value(current_value),
        .done(done)
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
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Traversal Completion", test_num);
            reset_dut();

            timeout = 0;

            while (!done && timeout < 20) begin
                @(posedge clk);
                timeout = timeout + 1;
            end



            #1;




            check_outputs(current_value, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset Mid-Traversal", test_num);
            reset_dut();


            repeat(2) @(posedge clk);


            reset_dut();


            #1;



            check_outputs(current_value, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Persistence of Done Signal", test_num);
            reset_dut();


            while (!done) @(posedge clk);


            repeat(5) @(posedge clk);


            #1;



            check_outputs(current_value, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Premature Done Check", test_num);
            reset_dut();



            #1;




            check_outputs(current_value, 1'b0);
        end
        endtask

    task testcase005;

        integer cycles;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full Sequence Length", test_num);
            reset_dut();

            cycles = 0;

            while (!done && cycles < 20) begin
                cycles = cycles + 1;
                @(posedge clk);
            end


            if (cycles >= 4) begin
                $display("Traversal took %0d cycles.", cycles);
                #1;

                check_outputs(current_value, 1'b1);
            end else begin
                $display("FAIL: Traversal was too short (%0d cycles).", cycles);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [7:0] expected_current_value;
        input expected_done;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, done=%b",
                         current_value, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, done=%b",
                         expected_current_value, expected_done);
                $display("  Got:      current_value=%h, done=%b",
                         current_value, done);
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
        $dumpvars(0,clk, reset, current_value, done);
    end

endmodule
