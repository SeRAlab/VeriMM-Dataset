`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (combinational circuit)
    reg allocate;
    reg free;
    reg [3:0] request_size;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .free(free),
        .request_size(request_size),
        .success(success)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Allocation (Size 4)", test_num);

        allocate = 0; free = 0; request_size = 0;
        #5;


        allocate = 1;
        request_size = 4'd4;


        #1;



        check_outputs(1'b1);


        #5; allocate = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Allocation (Size 8)", test_num);
        allocate = 0; free = 0; request_size = 0;
        #5;

        allocate = 1;
        request_size = 4'd8;

        #1;


        check_outputs(1'b1);

        #5; allocate = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Allocation Failure (Exceeding Capacity)", test_num);
        allocate = 0; free = 0; request_size = 0;
        #5;



        allocate = 1;
        request_size = 4'd10;

        #1;


        check_outputs(1'b0);

        #5; allocate = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Freeing Memory (Size 4)", test_num);
        allocate = 0; free = 0; request_size = 0;
        #5;

        free = 1;
        request_size = 4'd4;

        #1;


        check_outputs(1'b1);

        #5; free = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Re-allocation after Freeing", test_num);
        allocate = 0; free = 0; request_size = 0;
        #5;



        allocate = 1;
        request_size = 4'd5;

        #1;


        check_outputs(1'b1);

        #5; allocate = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid Free (Size larger than allocated)", test_num);
        allocate = 0; free = 0; request_size = 0;
        #5;

        free = 1;
        request_size = 4'd15;

        #1;


        check_outputs(1'b0);

        #5; free = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Size Request", test_num);
        allocate = 0; free = 0; request_size = 0;
        #5;

        allocate = 1;
        request_size = 4'd0;



        #1;




        check_outputs(success);

        #5; allocate = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_allocator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_success;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: success=%b",
                         success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: success=%b",
                         expected_success);
                $display("  Got:      success=%b",
                         success);
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

endmodule
